//
//  ContentView.swift
//  ApplePark
//
//  Created by 박준영 on 10/7/24.
//

import SwiftUI

struct LoginView: View {
    @State private var isPresented: Bool = false
    @State private var authState: AuthenticationState = .unauthenticated
    @EnvironmentObject var authManager: AuthManager
    var body: some View {
        NavigationStack {
            if isPresented {
                ProductAddView()
            }else {
                  VStack {
                    Button {
                        Task {
                            isPresented  = await authManager.signInWithGoogle()
                        }
                    } label: {
                        Text("Login Button")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .foregroundStyle(.white)
                            .background(.indigo.gradient, in: RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager())
}
