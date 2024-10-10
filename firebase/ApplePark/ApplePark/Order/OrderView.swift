//
//  OrderView.swift
//  ApplePark
//
//  Created by 김종혁 on 10/8/24.
//

import SwiftUI

struct OrderView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject private var orderStore: OrderStore
    
    let itemId: String
    let productName: String
    let imageURL: String
    let unitPrice: Int
    
    var body: some View {
        VStack {
            Text("email: \(authManager.email)")
                .padding()
            Text("ItemID: \(itemId)")
                .padding()
            Text("제품명: \(productName)")
                .padding()
            Text("단가: \(unitPrice)")
                .padding()
        }
        List {
            ForEach(orderStore.orders, id: \.orderDate) { order in
                HStack {
                    Text(order.productName)
                    Spacer()
                    Button(action: {
                        Task {
                            await orderStore.deleteOrder(order, userID: authManager.email)
                            await orderStore.loadOrder(userID: authManager.email)
                        }
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await orderStore.loadOrder(userID: authManager.email)
            }
        }
        
        Button {
            Task {
                let newOrder = Order(
                    trackingNumber: "19082947892",
                    orderDate: Date(),
                    shippingAddress: "우리집",
                    phoneNumber: "010-4444-3333",
                    productName: productName,
                    imageURL: imageURL,
                    color: "빨간색",
                    itemId: itemId,
                    hasAppleCarePlus: false,
                    quantity: 3,
                    unitPrice: unitPrice,
                    bankName: "국민은행",
                    accountNumber: "2194-1234-5678",
                    isPay: false
                )
                
                await orderStore.addOrder(newOrder, userID: authManager.email)
                await orderStore.loadOrder(userID: authManager.email)
            }
        } label: {
            Text("상품 추가")
                .font(.title)
        }
    }
}




//#Preview {
//    OrderView(itemId: "sampleItemId", productName: "Sample Product", imageURL: "http://example.com/image.jpg", unitPrice: 1000)
//}


