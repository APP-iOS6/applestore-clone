//
//  HeaderView.swift
//  ApplePark
//
//  Created by Hyunwoo Shin on 10/8/24.
//
import SwiftUI

@ViewBuilder
func productHeaderView(headerText: String, authManager: AuthManager) -> some View {
    HStack {
        Text(headerText)
            .font(.system(size: 32, weight: .bold))
        Spacer()
            
        Button {
            Task {
                await authManager.signInWithGoogle()
            }
        } label: {
            Image(systemName: "person.circle")
                .font(.system(size: 32, weight: .bold))
        }
        
    }
    .padding()
}

@ViewBuilder
func publicHeaderView(_ title: String) -> some View {
    HStack {
        Text(title)
            .font(.system(size: 20, weight: .bold))
        Spacer()
    }
    .padding()
}
