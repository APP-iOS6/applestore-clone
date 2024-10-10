//
//  View.swift
//  ApplePark
//
//  Created by 홍지수 on 10/10/24.
//

import SwiftUI

extension View {
    func CustomAlertView(
        isPresented: Binding<Bool>
    ) -> some View {
        return modifier(
            CustomAlertViewModifier(
                isPresented: isPresented
            )
        )
    }
}

