//
//  ProfileInfo.swift
//  AppleStore_Clone_Admin
//
//  Created by 박준영 on 10/10/24.
//

import Foundation

struct ProfileInfo: Codable, Identifiable {
    var id: String { email }
    var nickname: String               // 닉네임
    var email: String                  // 이메일
    var registrationDate: Date         // 가입날짜
    var recentlyViewedProducts: [String] // 최근 본 제품(상품 ID 리스트)
    
    // 가입 날짜 Formatter 생성
    var formattedRegistration: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일 HH시 mm분"
        return formatter.string(from: registrationDate)
    }
}
