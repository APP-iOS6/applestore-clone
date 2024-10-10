//
//  UserID.swift
//  ApplePark
//
//  Created by Soom on 10/7/24.
//

import Foundation

// 고객ID
struct UserID: Identifiable {
    var id: UUID = UUID() // 고객 아이디
    
    var order: [Order]
    var profileInfo: ProfileInfo
}


