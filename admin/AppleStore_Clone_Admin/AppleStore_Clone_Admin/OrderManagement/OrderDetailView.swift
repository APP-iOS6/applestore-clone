//
//  OrderDetailView.swift
//  AppleStore_Clone_Admin
//
//  Created by Jaemin Hong on 10/8/24.
// 

import SwiftUI

struct OrderDetailView: View {
    private var order: Order
    private var columns: [GridItem] = Array(repeating: GridItem(.fixed(250), spacing: 50), count: 3)
    
    init(order: Order) {
        self.order = order
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 50) {
                OrderInformationView(title: "주문 날짜", information: order.formattedOrder)
                OrderInformationView(title: "상품 명", information: order.productName)
                OrderInformationView(title: "상품 ID", information: order.itemId)
                
                OrderInformationView(title: "운송장 번호", information: order.trackingNumber)
                OrderInformationView(title: "배송 주소", information: order.shippingAddress)
                OrderInformationView(title: "전화번호", information: order.phoneNumber)
                
                OrderInformationView(title: "고객 명", information: order.nickname)
                OrderInformationView(title: "애플 케어 플러스 여부", information: order.hasAppleCarePlus ? "Yes" : "No")
                OrderInformationView(title: "제품 색상", information: order.color)
                
                OrderInformationView(title: "주문 수량", information: "\(order.quantity)")
                OrderInformationView(title: "단가", information: "₩\(order.unitPrice.formatted())")
                OrderInformationView(title: "총액", information: "₩\(order.totalPrice.formatted())")
                
                OrderInformationView(title: "은행 명", information: order.bankName)
                OrderInformationView(title: "계좌번호", information: order.accountNumber)
            }
        }
    }
}
