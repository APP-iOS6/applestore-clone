//
//  CustomerManagementView.swift
//  AppleStore_Clone_Admin
//
//  Created by 김정원 on 10/7/24.
//

import SwiftUI

struct CustomerManagementView: View {
    
    @State private var searchText: String = ""
    @State private var selectedCustomers: Set<ProfileInfo.ID> = []
    @State private var selectedCustomer: Customer? = nil  // 선택된 고객 초기화
    @State private var showDetails: Bool = false  // 상세 페이지 표시 여부
    @EnvironmentObject private var profileStore: ProfileStore
    
    private var filteredCustomers: [ProfileInfo] {
        if searchText.isEmpty {
            return profileStore.profiles
        } else {
            return profileStore.profiles.filter { $0.nickname.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                TextField("사용자 이름을 입력해주세요.", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Table(profileStore.profiles, selection: $selectedCustomers) {
                    TableColumn("사용자 이름") { customer in
                        Text(customer.nickname)
                            .font(.system(.title2))  // 폰트 크기 키우기
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)  // 셀 너비 늘리기
                    }
                    TableColumn("이메일", value: \.email)
                    TableColumn("가입 날짜") { customer in
                        Text(customer.formattedRegistration)
                    }
                    TableColumn("최근 본 제품") { customer in
                        Text("\(customer.recentlyViewedProducts.count)")
                    }
                }
//                .onChange(of: selectedCustomers) { newSelection in
//                    if let firstSelectedCustomerID = newSelection.first {
//                        if let customer = filteredCustomers.first(where: { $0.id == firstSelectedCustomerID }) {
//                            selectedCustomer = customer
//                            showDetails = true  // 고객이 선택되었을 때 상세 페이지 표시
//                        }
//                    } else {
//                        showDetails = false  // 고객 선택이 해제되면 상세 페이지 숨김
//                    }
//                }
                .onAppear {
                    // 화면이 처음 로드될 때 초기화
                    Task {
                        await profileStore.loadProfiles()
                    }
                    selectedCustomer = nil
                    selectedCustomers = []
                    showDetails = false
                }
                
                // NavigationLink를 선택된 고객을 기반으로 이동하도록 설정
                NavigationLink(
                    destination: Group {
                        if let selectedCustomer {
                            OrderListView(nickname: selectedCustomer.nickname)
                        }
                    },
                    isActive: $showDetails  // 상태 변경 시 활성화
                    
                ) {
                    EmptyView()
                }
            }
        }
        .navigationTitle("Customer Management")
    }
}

#Preview {
    CustomerManagementView()
}
