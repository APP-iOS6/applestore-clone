//
//  ProfileInfo.swift
//  ApplePark
//
//  Created by Soom on 10/8/24.
//

import SwiftUI

struct ProfileInfoView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("프로필 정보")
                
                Text("닉네임: \(authManager.profileInfo.nickname)")
                
                Text("가입 날짜: \(authManager.profileInfo.formattedRegistration)")
                
                if !authManager.profileInfo.recentlyViewedProducts.isEmpty {
                    Text("최근 본 제품:")
                    
                    ForEach(authManager.profileInfo.recentlyViewedProducts, id: \.self) { product in
                        Text("상품 ID: \(product)")
                            .font(.body)
                    }
                } else {
                    Text("최근 본 제품 없음.")
                }
                ProfileInfoAddView()
            }
            .font(.title)
            .padding()
            .navigationTitle("프로필")
            .onAppear {
                Task {
                    await authManager.loadUserProfile(email: authManager.email)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileInfoView()
    }
}
