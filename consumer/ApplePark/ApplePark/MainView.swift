//
//  MainView.swift
//  ApplePark
//
//  Created by 박준영 on 10/7/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        TabView {
            Tab("For You", systemImage: "list.bullet.rectangle.portrait") {
                ForYouView()
            }
            
            Tab("제품", systemImage: "macbook.and.iphone") {
                ProductView()
            }
            
            Tab("검색", systemImage: "magnifyingglass") {
                SearchView()
            }
            
            Tab("장바구니", systemImage: "bag") {
                BagView()
            }
        }
    }
}

#Preview {
    MainView()
}
