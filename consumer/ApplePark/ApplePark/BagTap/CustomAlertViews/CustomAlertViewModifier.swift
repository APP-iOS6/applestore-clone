//
//  CustomAlertViewModifier.swift
//  ApplePark
//
//  Created by 홍지수 on 10/10/24.
//

import SwiftUI

struct CustomAlertViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
//                .blur(radius: isPresented ? 2 : 0)
            ZStack {
                if isPresented {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .transition(.opacity)
                    
                    CustomAlertView(isPresented: self.$isPresented)
                }
            }
        }
        .animation(.snappy, value: isPresented)
    }
}
