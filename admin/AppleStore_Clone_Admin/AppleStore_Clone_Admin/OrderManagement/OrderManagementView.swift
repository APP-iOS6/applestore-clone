//
//  OrderManagementView.swift
//  AppleStore_Clone_Admin
//
//  Created by 김정원 on 10/7/24.
//

import SwiftUI

struct OrderManagementView: View {
    @EnvironmentObject var orderStore: OrderStore
    @State private var sortOrders = [
        KeyPathComparator(\Order.nickname, order: .forward),
        KeyPathComparator(\Order.formattedOrder, order: .forward),
        KeyPathComparator(\Order.quantity, order: .reverse)
    ]
    @State private var selectedOrderID: Order.ID? = nil
    @State private var selectedOrder: Order? = nil
    @State private var removeInfo: (userID: String, order: Order?) = ("", nil)
    @State private var showDetails: Bool = false
    @State private var showRemoveWarningAlert: Bool = false
    
    var body: some View {
        Table(orderStore.orders, selection: $selectedOrderID, sortOrder: $sortOrders) {
            TableColumn("주문 날짜", value: \.formattedOrder)
            TableColumn("상품 명", value: \.productName)
            TableColumn("주문 수량") { order in
                Text("\(order.quantity)")
            }
            TableColumn("단가") { order in
                Text("₩\(order.unitPrice)")
            }
            TableColumn("고객 명", value: \.nickname)
            TableColumn("배송 상태") { order in
                Picker("Delivery Status", selection: $orderStore.orders[ orderStore.orders.firstIndex(where: { $0.id == order.id } )! ].deliveryStatus
                ) {
                    ForEach(DeliveryStatus.allCases, id: \.self) { status in
                        Text("\(status.rawValue)")
                            .tag(status.rawValue)
                    }
                }
            }
            TableColumn("") { order in
                Button("주문 취소") {
                    removeInfo.order = orderStore.orders[ orderStore.orders.firstIndex(where: { $0.id == order.id })! ]
                    removeInfo.userID = order.userID
                    
                    showRemoveWarningAlert = true
                }
                .buttonStyle(.bordered)
                .foregroundStyle(.red)
                .font(.title2)
                .fontWeight(.bold)
            }
        }
        .onAppear {
            orderStore.orders.sort(using: sortOrders)
        }
        .onChange(of: sortOrders) {
            orderStore.orders.sort(using: sortOrders)
        }
        .onChange(of: selectedOrderID) {
            if let selectedOrderID {
                selectedOrder = orderStore.orders.first(where: { $0.id == selectedOrderID })
                
                self.selectedOrderID = nil
                showDetails = true
            }
        }
        .refreshable {
            Task {
                await orderStore.loadAllOrders()
            }
        }
        .alert("주문을 취소합니다", isPresented: $showRemoveWarningAlert, actions: {
            Button("진행하기", role: .destructive) {
                if let order = removeInfo.order {
                    Task {
                        await orderStore.deleteOrder(order, userID: removeInfo.userID)
                        print("주문이 취소되었습니다.")
                    }
                }
            }
            
            Button("돌아가기", role: .cancel) { }
        }, message: {
            Text("이 작업은 되돌릴 수 없습니다.")
        })
        .navigationDestination(isPresented: $showDetails) {
            if let selectedOrder {
                OrderDetailView(order: selectedOrder)
            }
        }
    }
}

#Preview {
    NavigationStack {
        OrderManagementView()
    }
}
