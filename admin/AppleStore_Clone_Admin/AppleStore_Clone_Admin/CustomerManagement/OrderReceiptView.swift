//
//  OrderReceiptView.swift
//  AppleStore_Clone_Admin
//
//  Created by Min on 10/8/24.
//

import SwiftUI

struct OrderReceiptView: View {
    var order: Order
    
    var formattedOrderDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: order.orderDate)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                HStack {
                    Text("주문 날짜:")
                        .font(.headline)
                        .frame(width: 120, alignment: .leading)
                    
                    Text(formattedOrderDate)
                        .font(.title2)  // 폰트 크기 키움
                }
                
                Divider()
                
                HStack {
                    Text("주문자:")
                        .font(.headline)
                        .frame(width: 120, alignment: .leading)
                    
//                    Text(order.nickname)
//                        .font(.title2)  // 폰트 크기 키움
                }
                
                Divider()
                
                HStack {
                    Text("배송지:")
                        .font(.headline)
                        .frame(width: 120, alignment: .leading)
                    
                    Text(order.shippingAddress)
                        .font(.title2)  // 폰트 크기 키움
                }
                
                Divider()
                
                HStack {
                    Text("전화번호:")
                        .font(.headline)
                        .frame(width: 120, alignment: .leading)
                    
                    Text(order.phoneNumber)
                        .font(.title2)  // 폰트 크기 키움
                }
                
                Divider()
                
                HStack {
                    Text("상품명:")
                        .font(.headline)
                        .frame(width: 120, alignment: .leading)
                    
                    Text(order.productName)
                        .font(.title2)  // 폰트 크기 키움
                }
                
                Divider()
                
                HStack {
                    Text("색상:")
                        .font(.headline)
                        .frame(width: 120, alignment: .leading)
                    
                    Text(order.color)
                        .font(.title2)  // 폰트 크기 키움
                }
                
                Divider()
                
                HStack {
                    Text("애플케어:")
                        .font(.headline)
                        .frame(width: 120, alignment: .leading)
                    
                    Text(order.hasAppleCarePlus ? "Yes" : "No")
                        .font(.title2)  // 폰트 크기 키움
                }
                
                Divider()
                
                HStack {
                    Text("수량:")
                        .font(.headline)
                        .frame(width: 120, alignment: .leading)
                    
                    Text("\(order.quantity)")
                        .font(.title2)  // 폰트 크기 키움
                }
                
                Divider()
                
                HStack {
                    Text("단가:")
                        .font(.headline)
                        .frame(width: 120, alignment: .leading)
                    
                    Text("\(order.unitPrice) 원")
                        .font(.title2)  // 폰트 크기 키움
                }
                
                Divider()
                
                HStack {
                    Text("은행:")
                        .font(.headline)
                        .frame(width: 120, alignment: .leading)
                    
                    Text(order.bankName)
                        .font(.title2)  // 폰트 크기 키움
                }
                
                Divider()
                
                HStack {
                    Text("계좌번호:")
                        .font(.headline)
                        .frame(width: 120, alignment: .leading)
                    
                    Text(order.accountNumber)
                        .font(.title2)  // 폰트 크기 키움
                }
            }
            .padding()
        }
        .navigationTitle("주문 상세 정보")
        .font(.system(size: 18)) // 기본 폰트 크기 조정
    }
}

//#Preview {
//    OrderReceiptView(order: sampleOrders[0])
//}
