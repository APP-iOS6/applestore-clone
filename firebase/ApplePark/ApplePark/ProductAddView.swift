//
//  ProductAddView.swift
//  ApplePark
//
//  Created by Soom on 10/7/24.
//

import SwiftUI

struct ProductAddView: View {
    let gridItem = Array(repeating: GridItem(.flexible()), count: 2)
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject private var itemStore: ItemStore
    @State private var isLogout: Bool = false
    @State private var isShowEditSheet: Bool = false
    @State private var itemDetail: Item? // 삭제할 아이템
    @State private var isShowDeleteAlert: Bool = false // 알림창 상태 관리
    
    @State private var selectedItem: Item = Item(name: "아이폰16pro",
                                                 category: "iPhone",
                                                 price: 100,
                                                 description: "description데이터",
                                                 stockQuantity: 1200,
                                                 imageURL: "image 데이터",
                                                 color: "color 데이터",
                                                 isAvailable: true)
    
    @State private var selectedCategory: String = "All"
    let categories = ["전체", "iPhone", "Mac", "Watch"]
    
    var body: some View {
        NavigationStack {
            if isLogout {
                LoginView()
            } else {
                TabView {
                    VStack {
                        Picker("카테고리 선택", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) { category in
                                Text(category).tag(category)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        .onChange(of: selectedCategory) { _, newCategory in
                            itemStore.filterByCategory(category: newCategory)
                        }
                        
                        ScrollView {
                            LazyVGrid(columns: gridItem) {
                                ForEach(itemStore.items, id: \.itemId) { item in
                                    Button(action: {
                                        //MARK: 관리자만 편집 가능하게
                                        if authManager.role == .admin {
                                            print(authManager.role)
                                            selectedItem = item
                                            isShowEditSheet.toggle()
                                        }
                                        Task {
                                            await itemStore.loadProducts()
                                        }
                                    }) {
                                        Text("\(item.name)")
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 300)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(itemDetail?.itemId == item.itemId ? Color.orange.opacity(0.5) : Color.orange)
                                            )
                                            .overlay(
                                                Group {
                                                    //MARK: 관리자만 삭제 가능
                                                    if authManager.role == .admin {
                                                        Button(action: {
                                                            itemDetail = item
                                                            isShowDeleteAlert.toggle()
                                                            print("선택한 아이템Id: \(item.itemId)")
                                                        }) {
                                                            Image(systemName: "trash")
                                                        }
                                                        .padding()
                                                    }
                                                }, alignment: .topTrailing
                                            )
                                            .overlay(
                                                NavigationLink(destination: OrderView(itemId: item.itemId, productName: item.name, imageURL: item.imageURL, unitPrice: item.price)) {
                                                    Image(systemName: "paperplane.circle.fill")
                                                }
                                                    .padding(), alignment: .topLeading
                                            )
                                    }
                                }
                            }
                        }
                        .sheet(isPresented: $isShowEditSheet) {
                            ProductEditView(isShowSheet: $isShowEditSheet, itemStore: itemStore, item: $selectedItem)
                        }
                        .onAppear {
                            Task {
                                await itemStore.loadProducts()
                            }
                        }
                        
                        Button {
                            authManager.signOut()
                            isLogout = true
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                        }
                    }

                    .tabItem {
                        Image(systemName: "house")
                        Text("Product")
                    }
                    
                    ProfileInfoView()
                        .tabItem {
                            Image(systemName: "person.circle.fill")
                            Text("Profile")
                        }
                }
                .padding(.horizontal, 20)
                .navigationTitle("Product Add View")
                .toolbar {
                    //MARK: 관리자만 추가 가능하게
                    if authManager.role == .admin {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                Task {
                                    await authManager.itemStore.addProduct(Item(name: "name데이터",
                                                                                category: "name데이터",
                                                                                price: 100,
                                                                                description: "name데이터",
                                                                                stockQuantity: 1200,
                                                                                imageURL: "name데이터",
                                                                                color: "name데이터",
                                                                                isAvailable: true), userID: authManager.userID)
                                    await itemStore.loadProducts()
                                }
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
                .alert(isPresented: $isShowDeleteAlert) {
                    Alert(title: Text("게시물 삭제"), message: Text("정말로 삭제하시겠습니까?"), primaryButton: .destructive(Text("삭제")) {
                        if let itemToDelete = itemDetail {
                            Task {
                                await itemStore.deleteProduct(itemToDelete, userID: authManager.userID) // 삭제
                                await itemStore.loadProducts() // 아이템 목록 로드
                                print("삭제된 아이템Id: \(itemToDelete.itemId)") // 삭제된 아이템의 ID 확인
                                itemDetail = nil // 선택한 아이템 초기화
                            }
                        }
                    }, secondaryButton: .cancel(Text("취소")) {
                        itemDetail = nil // 취소할 때 선택한 아이템 초기화
                    })
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProductAddView()
    }
    .environmentObject(AuthManager())
    .environmentObject(ItemStore())
}

