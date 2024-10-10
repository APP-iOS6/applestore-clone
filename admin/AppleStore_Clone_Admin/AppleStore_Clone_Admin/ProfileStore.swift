//
//  ProfileStore.swift
//  AppleStore_Clone_Admin
//
//  Created by 박준영 on 10/10/24.
//

import Foundation
import Observation
import SwiftUI
import FirebaseCore
import FirebaseFirestore

@MainActor
class ProfileStore: ObservableObject {
    @Published private(set) var profiles: [ProfileInfo] = []
    
    func loadProfiles() async {
        do {
            let db = Firestore.firestore()
            
            // "hasProfileInfo" 필드가 true인 문서만 쿼리
            let snapshots = try await db.collection("User").getDocuments()
            
            var savedProfiles: [ProfileInfo] = []
            
            for document in snapshots.documents {
                // 각 유저 문서에서 "profileInfo" 서브 콜렉션 가져오기
                let email: String = document.documentID
                
                let profileSnapshots = try await db.collection("User")
                    .document(document.documentID)
                    .collection("profileInfo")
                    .getDocuments()
                
                for profileDocument in profileSnapshots.documents {
                    let docData = profileDocument.data()
                    // let email: String = profileDocument.documentID
                    let name: String = docData["nickname"] as? String ?? ""
                    
                    let timestamp = docData["registrationDate"] as? Timestamp
                    let date = timestamp?.dateValue() ?? Date()
                    
                    let recentlyViews = docData["recentlyViewedProducts"] as? [String] ?? []
                    
                    let profile = ProfileInfo(nickname: name, email: email, registrationDate: date, recentlyViewedProducts: recentlyViews)
                    savedProfiles.append(profile)
                }
            }
            
            profiles = savedProfiles
            print(profiles)
            
        } catch {
            print("Error 고객 정보 불러오기: \(error)")
        }
    }
}
