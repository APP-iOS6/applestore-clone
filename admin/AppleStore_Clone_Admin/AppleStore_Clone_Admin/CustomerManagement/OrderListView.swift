//
//  CustomerDetailView.swift
//  AppleStore_Clone_Admin
//
//  Created by Min on 10/8/24.
//

import SwiftUI

struct OrderListView: View {
    
    var nickname: String
    @EnvironmentObject var orderStore: OrderStore
    @State private var selection: Order.ID? = nil  // 선택된 주문 ID를 저장할 상태 변수
    @State private var navigateToReceipt: Bool = false  // 네비게이션을 트리거할 상태 변수
    @State private var sortOrder = [KeyPathComparator(\Order.orderDate)]  // 주문 날짜만 정렬 기준으로 설정
    
    private var filteredOrders: [Order] {
        orderStore.orders.filter { $0.nickname == nickname }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
    // 정렬된 주문 리스트를 변수로 분리
    @State private var sortedOrders: [Order] = []  // 초기값을 빈 배열로 설정
    
    var body: some View {
        
        NavigationStack {
            VStack {
                // 정렬된 주문 리스트 사용
                Table(sortedOrders, selection: $selection, sortOrder: $sortOrder) {
                    TableColumn("주문 날짜", value: \.orderDate) { order in
                        Text(formatDate(order.orderDate))
                            .font(.system(.title3))  // 폰트 크기 키우기
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    TableColumn("주문자", value: \.nickname)
                    
                    TableColumn("배송지", value: \.shippingAddress)
                    
                    TableColumn("전화번호", value: \.phoneNumber)
                    
                    TableColumn("상품명", value: \.productName)
                    
                    TableColumn("색상", value: \.color)
                    
                    TableColumn("애플케어") { order in
                        Text(order.hasAppleCarePlus ? "Yes" : "No")
                    }
                    
                    TableColumn("수량") { order in
                        Text("\(order.quantity) 개")
                    }
                    
                    TableColumn("단가", value: \.unitPrice) { order in
                        Text("\(order.unitPrice) 원")
                    }
                    
                    TableColumn("은행", value: \.bankName)
                }
                .onChange(of: sortOrder) { newSortOrder in
                    // 정렬 기준 변경 시 필터된 주문을 다시 정렬
                    sortedOrders = filteredOrders.sorted(using: newSortOrder)
                }
                
                .onChange(of: selection) { newSelection in
                    if let selectedID = newSelection {
                        // 선택된 주문을 찾고 네비게이션을 트리거합니다.
                        if let order = sortedOrders.first(where: { $0.id == selectedID }) {
                            navigateToReceipt = true
                        }
                    }
                }
                
                // 상세 페이지로 이동할 링크
                NavigationLink(
                    destination: Group {
                        if let selectedOrder = sortedOrders.first(where: { $0.id == selection }) {
                            OrderReceiptView(order: selectedOrder)
                        }
                    },
                    isActive: $navigateToReceipt,
                    label: { EmptyView() }
                )
                .hidden()
            }
            .onAppear {
                // 화면이 처음 로드될 때 초기화
                selection = nil
                navigateToReceipt = false
                // 화면 로드 시 초기 정렬된 주문 리스트 설정
                sortedOrders = filteredOrders.sorted(using: sortOrder)
            }
        }
        .navigationTitle("\(nickname) 님의 주문 내역")
    }
}

#Preview {
    OrderListView(nickname: "alice")
}
