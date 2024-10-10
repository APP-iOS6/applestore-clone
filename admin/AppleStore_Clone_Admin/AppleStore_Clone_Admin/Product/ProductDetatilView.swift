//
//  ProductDetatilView.swift
//  AppleStore_Clone_Admin
//
//  Created by 김정원 on 10/7/24.
//

import SwiftUI
import FirebaseFirestore

struct ProductDetailView: View {
    @State private var isEditing = false
    @State private var originalProduct: Item // 원본 아이템을 저장
    @State var product: Item
    @EnvironmentObject private var itemStore: ItemStore
    
    init(product: Item) {
        self._product = State(initialValue: product)
        self._originalProduct = State(initialValue: product)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 상품 이미지 섹션
                HStack {
                    Spacer() // 가운데 정렬을 위한 Spacer
                    if let url = URL(string: product.imageURL), !product.imageURL.isEmpty {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 300)
                                .cornerRadius(10)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 250)
                    } else {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(height: 250)
                            .cornerRadius(10)
                            .overlay(Text("이미지 없음").foregroundColor(.white))
                            .frame(maxWidth: 300)
                    }
                    Spacer() // 가운데 정렬을 위한 Spacer
                }
                .padding(.top)
                
                // 상품 정보 섹션
                VStack(alignment: .leading, spacing: 15) {
                    editableField(title: "상품명", value: $product.name)
                    editableField(title: "카테고리", value: $product.category)
                    editableField(title: "가격", value: $product.price, isNumber: true)
                    editableField(title: "상세설명", value: $product.description)
                    editableField(title: "재고 수량", value: $product.stockQuantity, isNumber: true)
                    editableField(title: "색상", value: $product.color)
                    
                    if isEditing {
                        TextField("이미지 URL", text: $product.imageURL)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                    }
                    
                    Toggle("판매 중", isOn: $product.isAvailable)
                        .padding(.horizontal)
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                        .disabled(!isEditing)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("상품 상세 정보")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if isEditing {
                        HStack {
                            Button("Cancel") {
                                // 원래 상태로 되돌림
                                product = originalProduct
                                isEditing = false
                            }
                            Button("Save") { 
                                // 저장 후 편집 모드 종료
                                Task {
                                    await itemStore.updateProducts(product)
                                }
                                isEditing = false
                            }
                        }
                    } else {
                        Button("Edit") {
                            isEditing = true
                        }
                    }
                }
            }
        }
        .background(Color(UIColor.systemBackground)) // 기본 배경색
    }
    
    // 편집 가능한 필드 텍스트
    @ViewBuilder
    private func editableField(title: String, value: Binding<String>, isNumber: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            
            if isEditing {
                if isNumber {
                    TextField(title, value: value, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    TextField(title, text: value)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            } else {
                Text(value.wrappedValue)
                    .font(.body)
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal)
    }
    
    // 편집 가능한 필드 숫자형
    @ViewBuilder
    private func editableField(title: String, value: Binding<Int>, isNumber: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            
            if isEditing {
                TextField(title, value: value, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text("\(value.wrappedValue)")
                    .font(.body)
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: sampleItems[0])
            .environmentObject(ItemStore())
    }
}
