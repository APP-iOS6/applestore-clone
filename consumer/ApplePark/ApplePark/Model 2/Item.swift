//
//  Item.swift
//  ApplePark
//
//  Created by 김종혁 on 10/7/24.
//

import Foundation

// 제품 관리
//struct Item: Codable {
//    var itemId: String = UUID().uuidString    // 상품ID
//    var name: String        // 상품명
//    var category: String    // 카테고리
//    var price: Int          // 가격
//    var description: String // 상세설명
//    var stockQuantity: Int  // 재고수량
//    var imageURL: String    // 이미지 URL
//    var color: String       // 색상
//    var isAvailable: Bool   // 상품상태(품절, 판매중 / Bool)
//    
//    // price가격을 천 단위 구분
//    var formattedPrice: String {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .decimal
//        numberFormatter.groupingSeparator = "," // 천 단위 구분
//        if let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) {
//            return formattedPrice
//        } else {
//            return "\(price)"
//        }
//    }
//}
