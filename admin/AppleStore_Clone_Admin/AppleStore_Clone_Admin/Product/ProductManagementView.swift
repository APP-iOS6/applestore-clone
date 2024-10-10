//
//  ProductManagementView.swift
//  AppleStore_Clone_Admin
//
//  Created by 김정원 on 10/7/24.
//

import SwiftUI

struct ProductManagementView: View {
    // 상품 카테고리 목록
    @State private var isShowingAddProductView = false
    @EnvironmentObject private var itemStore: ItemStore

    
    var body: some View {
        NavigationStack {
            List {
                ForEach(ProductType.allCases, id: \.self) { category in
                    Section(header: Text(category.rawValue)) {
                        ForEach(itemStore.filterItems(for: category), id: \.itemId) { item in
                            NavigationLink(destination: ProductDetailView(product: item)) {
                                HStack {
                                    if let url = URL(string: item.imageURL), !item.imageURL.isEmpty {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 40, height: 40)
                                    } else {
                                        Rectangle()
                                            .fill(Color.gray)
                                            .frame(height: 200)
                                            .overlay(Text("이미지 없음").foregroundColor(.white))
                                    }
                                    Text(item.name)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let itemToDelete = itemStore.filterItems(for: category)[index]
                                
                                
                                Task {
                                    await itemStore.deleteProduct(itemToDelete)
                                }
                               // print(itemToDelete)

                            }
                        }
                    }
                }
            }
            .navigationTitle("상품 관리")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isShowingAddProductView.toggle()
                    }) {
                        Label("상품 추가하기", systemImage: "plus.circle.fill")
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingAddProductView) {
            NavigationStack {
                ProductUploadView()
            }
        }
        .onAppear {
            Task {
                await itemStore.loadProducts()
            }
        }
    }
}

#Preview {
    ProductManagementView()
}

