//
//  ContentView.swift
//  AppleStore_Clone_Admin
//
//  Created by 김정원 on 10/7/24.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            Tab("상품관리", systemImage: "cart") {
                ProductManagementView()
            }
            
            Tab("주문관리", systemImage: "list.bullet.rectangle") {
                NavigationStack {
                    OrderManagementView()
                }
            }
            
            Tab("고객관리", systemImage: "person.3") {
                CustomerManagementView()
            }
            
            Tab("통계", systemImage: "chart.bar") {
                StatisticsView(productSalesData: dummyProductSalesData, monthlySalesData: dummyMonthlySalesData)
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}


#Preview {
    ContentView()
}
