//
//  LoginView.swift
//  AppleStore_Clone_Admin
//
//  Created by 김정원 on 10/8/24.
//

import SwiftUI

struct LoginView: View {
    @State private var isPresented: Bool = true
    @State private var authState: AuthenticationState = .unauthenticated
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        VStack {
            if isPresented {
                ContentView()
            } else {
                Button(action: {
                    Task {
                        isPresented  = await authManager.signInWithGoogle()
                    }
                }) {
                    HStack {
                        Image("symbolGoogle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding(.trailing, 8)
                        
                        Text("Google 로그인")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(.white)
                }
                .border(.secondary,width: 1)
                .clipShape(RoundedRectangle(cornerRadius: 2))
                .padding()
            }
        }
        .navigationTitle("Applstore Admin")
    }
        
}

#Preview {
    NavigationStack {
        LoginView()
            .environmentObject(AuthManager())
            .environmentObject(ItemStore())
    }
}
