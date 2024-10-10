//
//  SampleData.swift
//  ApplePark
//
//  Created by 김종혁 on 10/7/24.
//

import Foundation

// 샘플 데이터를 위한 날짜 생성기
func sampleDate(daysAgo: Int) -> Date {
    let calendar = Calendar.current
    return calendar.date(byAdding: .day, value: -daysAgo, to: Date())!
}

// 샘플 상품 데이터 생성
let sampleItems = [
    Item(itemId: UUID().uuidString,
         name: "iPhone 14",
         category: "iPhone",
         price: 1200000,
         description: "애플의 최신 스마트폰",
         stockQuantity: 10,
         imageURL: "https://assets.swappie.com/cdn-cgi/image/width=600,height=600,fit=contain,format=auto/swappie-iphone-13-pro-sierra-blue-back.png?v=a58d97a7",
         color: "151,32,100/메탈릭로제",
         isAvailable: true),
    
    Item(itemId: UUID().uuidString,
         name: "iPhone 16 Pro Max",
         category: "iPhone",
         price: 1100000,
         description: "삼성의 최신 스마트폰",
         stockQuantity: 8,
         imageURL: "https://assets.swappie.com/cdn-cgi/image/width=600,height=600,fit=contain,format=auto/swappie-iphone-13-pro-sierra-blue-back.png?v=a58d97a7",
         color: "151,32,100/메탈릭로제",
         isAvailable: true),
    
    Item(itemId: UUID().uuidString,
         name: "iPad 13 Pro",
         category: "iPad",
         price: 2500000,
         description: "LG의 최신 OLED TV",
         stockQuantity: 5,
         imageURL: "https://assets.swappie.com/cdn-cgi/image/width=600,height=600,fit=contain,format=auto/swappie-iphone-13-pro-sierra-blue-back.png?v=a58d97a7",
         color: "151,32,100/메탈릭로제",
         isAvailable: true),
    
    Item(itemId: UUID().uuidString,
         name: "iPad 14 Pro",
         category: "iPad",
         price: 900000,
         description: "강력한 흡입력의 다이슨 청소기",
         stockQuantity: 15,
         imageURL: "https://assets.swappie.com/cdn-cgi/image/width=600,height=600,fit=contain,format=auto/swappie-iphone-13-pro-sierra-blue-back.png?v=a58d97a7",
         color: "151,32,100/메탈릭로제",
         isAvailable: true),
    
    Item(itemId: UUID().uuidString,
         name: "Mac M3 Pro",
         category: "Mac",
         price: 1500000,
         description: "가볍고 강력한 삼성 노트북",
         stockQuantity: 7,
         imageURL: "https://assets.swappie.com/cdn-cgi/image/width=600,height=600,fit=contain,format=auto/swappie-iphone-13-pro-sierra-blue-back.png?v=a58d97a7",
         color: "151,32,100/메탈릭로제",
         isAvailable: true)
]

let sampleOrders = [
    Order(trackingNumber: UUID().uuidString,
          orderDate: sampleDate(daysAgo: 5),
          //nickname: "john_doe",
          shippingAddress: "서울특별시 강남구 테헤란로 123",
          phoneNumber: "010-1234-5678",
          productName: "아이폰 14",
          imageURL: "https://example.com/iphone14.jpg",
          color: "블랙",
          itemId: sampleItems[0].itemId,
          hasAppleCarePlus: true,
          quantity: 2,
          unitPrice: 1200000,
          bankName: "국민은행",
          accountNumber: "123-456-789",
          isPay: false),
    
    Order(trackingNumber: UUID().uuidString,
          orderDate: sampleDate(daysAgo: 10),
          //nickname: "jane_doe",
          shippingAddress: "부산광역시 해운대구 우동 456",
          phoneNumber: "010-9876-5432",
          productName: "갤럭시 S23",
          imageURL: "https://example.com/galaxys23.jpg",
          color: "화이트",
          itemId: sampleItems[1].itemId,
          hasAppleCarePlus: false,
          quantity: 1,
          unitPrice: 1100000,
          bankName: "우리은행",
          accountNumber: "987-654-321",
          isPay: false),
    
    Order(trackingNumber: UUID().uuidString,
          orderDate: sampleDate(daysAgo: 15),
          //nickname: "alice",
          shippingAddress: "인천광역시 남동구 구월동 789",
          phoneNumber: "010-1111-2222",
          productName: "LG OLED TV",
          imageURL: "https://example.com/lgoledtv.jpg",
          color: "검정",
          itemId: sampleItems[2].itemId,
          hasAppleCarePlus: true,
          quantity: 1,
          unitPrice: 2500000,
          bankName: "신한은행",
          accountNumber: "123-987-456",
          isPay: false),
    
    Order(trackingNumber: UUID().uuidString,
          orderDate: sampleDate(daysAgo: 20),
          //nickname: "bob",
          shippingAddress: "대전광역시 유성구 봉명동 234",
          phoneNumber: "010-3333-4444",
          productName: "다이슨 무선 청소기",
          imageURL: "https://example.com/dyson.jpg",
          color: "실버",
          itemId: sampleItems[3].itemId,
          hasAppleCarePlus: false,
          quantity: 1,
          unitPrice: 900000,
          bankName: "KDB산업은행",
          accountNumber: "321-654-987",
          isPay: false),
    
    Order(trackingNumber: UUID().uuidString,
          orderDate: sampleDate(daysAgo: 25),
         // nickname: "charlie",
          shippingAddress: "광주광역시 서구 화정동 123",
          phoneNumber: "010-5555-6666",
          productName: "삼성 노트북",
          imageURL: "https://example.com/samsun_laptop.jpg",
          color: "은색",
          itemId: sampleItems[4].itemId,
          hasAppleCarePlus: true,
          quantity: 2,
          unitPrice: 1500000,
          bankName: "하나은행",
          accountNumber: "654-321-987",
          isPay: false)
]

//샘플 고객 데이터 생성
//let sampleCustomers = [
//    Customer(nickname: "john_doe",
//             email: "john@example.com",
//             registrationDate: sampleDate(daysAgo: 30),
//             recentlyViewedProducts: [sampleItems[0].itemId, sampleItems[1].itemId]),
//    
//    Customer(nickname: "jane_doe",
//             email: "jane@example.com",
//             registrationDate: sampleDate(daysAgo: 20),
//             recentlyViewedProducts: [sampleItems[1].itemId, sampleItems[2].itemId]),
//    
//    Customer(nickname: "alice",
//             email: "alice@example.com",
//             registrationDate: sampleDate(daysAgo: 15),
//             recentlyViewedProducts: [sampleItems[2].itemId, sampleItems[3].itemId]),
//    
//    Customer(nickname: "bob",
//             email: "bob@example.com",
//             registrationDate: sampleDate(daysAgo: 10),
//             recentlyViewedProducts: [sampleItems[3].itemId, sampleItems[4].itemId]),
//    
//    Customer(nickname: "charlie",
//             email: "charlie@example.com",
//             registrationDate: sampleDate(daysAgo: 5),
//             recentlyViewedProducts: [sampleItems[4].itemId, sampleItems[0].itemId])
//]
//
//
//
//// 샘플 UserID 데이터 생성
//let sampleUserID = UserID(id: UUID(), item: sampleItems, order: sampleOrders, customer: sampleCustomers)
