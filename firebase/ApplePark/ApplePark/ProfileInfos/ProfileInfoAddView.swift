//
//  ProfileInfo.swift
//  ApplePark
//
//  Created by Soom on 10/10/24.
//

import SwiftUI

struct ProfileInfoAddView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var newNickname: String = ""
    @State private var newRecentlyViewedProducts: [String] = ["sdfasdfas","dfasdfasdfasdfa"]
    
    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $newNickname)
                    .background(.red)
                Button(action: {
                    Task {
                        await authManager.updateUserProfile(nickname: newNickname, recentlyViewedProducts: newRecentlyViewedProducts)
                    }
                }, label: {
                    Text("수정하기")
                })
            }
            .navigationTitle("Profile Edit")
            
        }
        .onAppear {
            newNickname = authManager.profileInfo.nickname
            }
        }
}

#Preview {
    ProfileInfoView()
        .environmentObject(AuthManager())
}
