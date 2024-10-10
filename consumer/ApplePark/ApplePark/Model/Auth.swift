////
////  Auth.swift
////  ApplePark
////
////  Created by 홍지수 on 10/10/24.
////
//
//import SwiftUI
//import Foundation
//import FirebaseCore
//import FirebaseFirestore
//import GoogleSignInSwift
//@preconcurrency import FirebaseAuth
//@preconcurrency import GoogleSignIn
//
//public enum AuthenticationState {
//    case unauthenticated
//    case authenticating
//    case authenticated
//}
//
//public enum AuthenticationFlow {
//    case login
//    case signUp
//}
//
//@MainActor
//open class AuthManager: ObservableObject {
//    @Published var flow: AuthenticationFlow = .login
//    @Published var authenticationState: AuthenticationState = .unauthenticated
//    @Published var errorMessage: String = ""
//    
//    @Published public var userID: String = ""
//    @Published public var itemStore: ItemStore
//    public init() {
//        self.itemStore = ItemStore()
//    }
//}
//
//enum AuthenticationError: Error {
//    case tokenError(message: String)
//}
//
//extension AuthManager {
//    public func signInWithGoogle() async -> Bool {
//        guard let clientID = FirebaseApp.app()?.options.clientID else {
//            fatalError("No client ID found in Firebase configuration")
//        }
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
//        
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let window = windowScene.windows.first,
//              let rootViewController = window.rootViewController else {
//            print("There is no root view controller!")
//        
//            return false
//        }
//        
//        do {
//            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
//            
//            let user = userAuthentication.user
//            guard let idToken = user.idToken else { throw AuthenticationError.tokenError(message: "ID token missing") }
//            let accessToken = user.accessToken
//            
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
//                                                           accessToken: accessToken.tokenString)
//            
//            let result = try await Auth.auth().signIn(with: credential)
//            let firebaseUser = result.user
//            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
//            
//            self.userID = firebaseUser.uid
//            authenticationState = .authenticated
//            return true
//        }
//        catch {
//            print(error.localizedDescription)
//            self.errorMessage = error.localizedDescription
//            return false
//        }
//    }
//}
