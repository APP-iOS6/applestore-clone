//
//  OrderInformationView.swift
//  AppleStore_Clone_Admin
//
//  Created by Jaemin Hong on 10/8/24.
// 

import SwiftUI

struct OrderInformationView: View {
    var title: String
    var information: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(width: 250, height: 50)
                .minimumScaleFactor(0.05)
            
            Divider()
            
            Text(information)
                .font(.title)
                .frame(width: 250, height: 50)
                .minimumScaleFactor(0.03)
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = information
                    } label: {
                        Label("복사하기", systemImage: "document.on.document")
                    }
                    
                    ShareLink(item: information, message: Text(information))
                }
        }
    }
}
