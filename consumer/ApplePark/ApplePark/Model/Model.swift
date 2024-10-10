////
////  Model.swift
////  ApplePark
////
////  Created by 홍지수 on 10/10/24.
////
//
//// The Swift Programming Language
//// https://docs.swift.org/swift-book
//
//import SwiftUI
//import Foundation
//
//// 제품 관리
//public struct Item: Codable, Sendable {
//    public var itemId: String = UUID().uuidString    // 상품ID
//    public  var name: String        // 상품명
//    public var category: String    // 카테고리
//    public var price: Int          // 가격
//    public var description: String // 상세설명
//    public var stockQuantity: Int  // 재고수량
//    public var imageURL: String    // 이미지 URL
//    public  var color: String       // 색상
//    public  var isAvailable: Bool   // 상품상태(품절, 판매중 / Bool)
//    
//    public static let dummyData = Item(itemId: "1", name: "Dummy Item", category: "Dummy Category", price: 1000, description: "Dummy Description", stockQuantity: 10, imageURL: "https://example.com/image.jpg", color: "Dummy Color", isAvailable: true)
//    public init(itemId: String, name: String, category: String, price: Int, description: String, stockQuantity: Int, imageURL: String, color: String, isAvailable: Bool) {
//        self.itemId = itemId
//        self.name = name
//        self.category = category
//        self.price = price
//        self.description = description
//        self.stockQuantity = stockQuantity
//        self.imageURL = imageURL
//        self.color = color
//        self.isAvailable = isAvailable
//    }
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
//
//public struct Order: Codable {
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
//    public init(trackingNumber: String, orderDate: Date, nickname: String, shippingAddress: String, phoneNumber: String, productName: String, imageURL: String, color: String, itemId: String, hasAppleCarePlus: Bool, quantity: Int, unitPrice: Int, bankName: String, accountNumber: String) {
//        self.trackingNumber = trackingNumber
//        self.orderDate = orderDate
//        self.nickname = nickname
//        self.shippingAddress = shippingAddress
//        self.phoneNumber = phoneNumber
//        self.productName = productName
//        self.imageURL = imageURL
//        self.color = color
//        self.itemId = itemId
//        self.hasAppleCarePlus = hasAppleCarePlus
//        self.quantity = quantity
//        self.unitPrice = unitPrice
//        self.bankName = bankName
//        self.accountNumber = accountNumber
//    }
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
//
//// 고객ID
//public struct UserID: Identifiable {
//    public var id: UUID = UUID() // 고객 아이디
//    var order: [Order]
//    var profileInfo: ProfileInfo
//    
//    public init(order: [Order], profileInfo: ProfileInfo) {
//        self.order = order
//        self.profileInfo = profileInfo
//    }
//}
//
//// 고객 관리
//public struct ProfileInfo: Codable, Sendable {
//    var nickname: String               // 닉네임
//    var email: String                  // 이메일
//    var registrationDate: Date         // 가입날짜
//    var recentlyViewedProducts: [String] // 최근 본 제품(상품 ID 리스트)
//    
//    static let dummyData = ProfileInfo(nickname: "김민수", email: "minsoo@gmail.com", registrationDate: Date(), recentlyViewedProducts: [])
//   
//    public init(nickname: String, email: String, registrationDate: Date, recentlyViewedProducts: [String]) {
//        self.nickname = nickname
//        self.email = email
//        self.registrationDate = registrationDate
//        self.recentlyViewedProducts = recentlyViewedProducts
//    }
//    // 가입 날짜 Formatter 생성
//    var formattedRegistration: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM월 dd일 HH시 mm분"
//        return formatter.string(from: registrationDate)
//    }
//}
//public protocol ItemStoreType {
//    func addProduct(_ item: Item, userID: String) async
//    func updateProducts(_ item: Item) async
//    func loadProducts() async
//    func deleteProduct(_ item: Item, userID: String) async
//}
