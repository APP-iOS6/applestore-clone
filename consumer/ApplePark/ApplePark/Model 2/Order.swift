//
//  Order.swift
//  ApplePark
//
//  Created by 김종혁 on 10/7/24.
//

import Foundation

// 주문 관리
//struct Order: Codable {
//    var trackingNumber: String
//    var orderDate: Date                // 주문 날짜
//    var nickname: String               // 닉네임
//    var shippingAddress: String        // 배송지
//    var phoneNumber: String            // 전화번호
//    var productName: String            // 상품명
//    var imageURL: String               // 이미지 URL
//    var color: String                  // 색상
//    var itemId: String                // 상품ID
//    
//    var hasAppleCarePlus: Bool         // 애플 케어 플러스 유무
//    var quantity: Int                  // 수량
//    var unitPrice: Int                 // 단가
//    
//    var bankName: String               // 은행명
//    var accountNumber: String          // 계좌번호
//    
//    // *수량 + 애플 케어가 true라면 기존 가격에서 10% 더함
//    var totalPrice: Int {
//        let total = (quantity * unitPrice) + ((quantity/10) * quantity)
//        return hasAppleCarePlus ? total : (quantity * unitPrice)
//    }
//    
//    // 날짜 Formatter 생성
//    var formattedOrder: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM월 dd일 HH시 mm분"
//        return formatter.string(from: orderDate)
//    }
//}
