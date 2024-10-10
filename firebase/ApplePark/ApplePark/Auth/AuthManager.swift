//
//  AuthenticationStore.swift
//  ApplePark
//
//  Created by 김종혁 on 10/7/24.
//

import Foundation
import Observation

import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import FirebaseFirestore

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signUp
}

enum UserRole {
    case admin      // 관리자
    case consumer   // 소비자
}

@MainActor
class AuthManager: ObservableObject {
    @Published var name: String = "unkown"
    @Published var email: String = ""
    @Published var isValid: Bool  = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage: String = ""
    @Published var user: User?
    @Published var displayName: String = ""
    @Published var photoURL: URL?
    @Published var userID: String = ""
    @Published var itemStore: ItemStore = ItemStore()
    

    @Published var profileInfo: ProfileInfo = ProfileInfo(nickname: "", registrationDate: Date(), recentlyViewedProducts: [])
    @Published var role: UserRole = .consumer
    
    init() {
        registerAuthStateHandler()
    }
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.displayName ?? ""
                self.photoURL = user?.photoURL
                self.email = user?.email ?? "" // 사용자 이메일 설정
                
                self.checkUserRole(email: self.email) // 역할 확인
            }
        }
    }
    
    //MARK: 관리자, 소비자 확인 함수
    private func checkUserRole(email: String) {
        let adminEmail = ["428bbell@gmail.com","tnswhdgkwk@gmail.com"] // 관리자 이메일 넣어야합니당
        if adminEmail.contains(email) {
            self.role = .admin
        } else {
            self.role = .consumer
        }
    }
}

extension AuthManager {
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.email = ""
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
}

enum AuthenticationError: Error {
    case tokenError(message: String)
}

extension AuthManager {
    func createProfile(nickname: String) async {
        do {
            let profileInfo = ProfileInfo(nickname: "", registrationDate: Date(), recentlyViewedProducts: [])
            let db = Firestore.firestore()
            try await db.collection("User").document(email).collection("profileInfo").document("profileDoc").setData([
                "nickname": nickname,
                "recentlyViewedProducts": profileInfo.recentlyViewedProducts,
                "registrationDate": profileInfo.registrationDate,
            ])
        } catch {
            print(error)
        }
    }
    func loadUserProfile(email: String) async {
        do {
            let db = Firestore.firestore()
            let snapshots = try await db.collection("User").document(email).collection("profileInfo").getDocuments()
            
            for document in snapshots.documents {
                let docData = document.data()
                let nickname: String = email
                
                let registrationTimestamp = docData["registrationDate"] as? Timestamp
                let registrationDate: Date = registrationTimestamp?.dateValue() ?? Date()
                
                let recentlyViewedProducts: [String] = docData["recentlyViewedProducts"] as? [String] ?? []
                
                self.profileInfo = ProfileInfo(
                    nickname: nickname,
                    registrationDate: registrationDate,
                    recentlyViewedProducts: recentlyViewedProducts
                )
            }
        } catch{
            print("\(error)")
        }
    }
    
    func updateUserProfile(nickname: String,recentlyViewedProducts: [String]) async {
            do {
                let db = Firestore.firestore()
                let docRef = db.collection("User").document(email).collection("profileInfo").document("profileDoc")

                try await docRef.setData([
                    "nickname": nickname,
                    "recentlyViewedProducts": recentlyViewedProducts,
                    "registrationDate": FieldValue.serverTimestamp()
                    ]
                )

                self.profileInfo.nickname = email
                self.profileInfo.recentlyViewedProducts = recentlyViewedProducts
                print("profile edit!!")

            } catch {
                print("\(error)")
            }
        }
    
    func signInWithGoogle() async -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found in Firebase configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller!")

            return false
        }
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            let user = userAuthentication.user
            guard let idToken = user.idToken else { throw AuthenticationError.tokenError(message: "ID token missing") }
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
            
            self.userID = firebaseUser.uid

            self.email = firebaseUser.email ?? ""  // 구글 로그인하면 이메일 설정
            await loadUserProfile(email: email)
           
            await createProfile(nickname: email)
            authenticationState = .authenticated
            return true
        }
        catch {
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
            return false
        }
    }
}


