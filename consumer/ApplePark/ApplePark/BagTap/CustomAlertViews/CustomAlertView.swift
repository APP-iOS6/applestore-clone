//
//  CustomAlertView.swift
//  ApplePark
//
//  Created by 홍지수 on 10/10/24.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        
        if isPresented {
            VStack(spacing: 20) {
                Text("필요한 결제 정보를 모두 입력하세요.")
                //                            .multilineTextAlignment(.center)
                    .padding(.vertical)
                Divider()
                Button("승인") {
                    isPresented = false  // 승인 버튼 클릭 시 알림 닫기
                }
                .padding()
            }
            .frame(width: 300)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
            )
        }
    }
}

//#Preview {
//    CustomAlertView()
//}
