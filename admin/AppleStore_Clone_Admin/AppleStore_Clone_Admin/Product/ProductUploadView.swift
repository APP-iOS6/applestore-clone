//
//  ProductUploadView.swift
//  AppleStore_Clone_Admin
//
//  Created by 김정원 on 10/7/24.
//

import SwiftUI

struct ProductUploadView: View {
    @State var itemName: String = ""
    @State var itemImageURL: String = ""
    @State var itemCategori: String = ""
    @State var itemColor: String = ""
    @State var itemPrice: String = ""
    @State var itemQuantity: String = ""
    @State var itemSummary: String = ""
    @EnvironmentObject private var itemStores: ItemStore
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack() {
                StringTextField(title: "1. 상품명", fieldData: $itemName, summary: "이름을 작성해주세요")
                
                StringTextField(title: "2. 이미지", fieldData: $itemImageURL, summary: "URL를 작성해주세요")
                
                CategoriSelectionMenu(selectedCategori: $itemCategori)
                
                ColorSelectionMenu(selectedColor: $itemColor)
                
                StringTextField(title: "5. 가격", fieldData: $itemPrice, summary: "가격을 작성해주세요")
                
                StringTextField(title: "6. 수량", fieldData: $itemQuantity, summary: "수량을 작성해주세요")
                
                SummaryTextField(fieldData: $itemSummary)
            }
        }
        .scrollIndicators(.hidden)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Text("취소")
                        .foregroundStyle(.red)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    Task {
                        await itemStores.addProduct(Item(name: itemName, category: itemCategori, price: Int(itemPrice) ?? 0, description: itemSummary, stockQuantity: Int(itemQuantity) ?? 0, imageURL: itemImageURL, color: itemColor, isAvailable: true), userID: UUID().uuidString)
                        dismiss()
                    }
                }) {
                    Text("등록하기")
                }
            }
        }
        .navigationTitle("상품 추가하기")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StringTextField: View {
    var title: String
    @Binding var fieldData: String
    var summary: String
    
    var body: some View {
        HStack() {
            Text(title)
                .font(.title)
                .padding()
            
            Spacer()
            
            TextField(text: $fieldData) {
                Text(summary)
            }
            .frame(width: 200)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.gray, lineWidth: 1.5)
            }
        }
        .padding()
    }
}

struct CategoriSelectionMenu: View {
    var categoris = ["iPhone", "AppleWatch", "iPad", "Mac", "AirPods", "Apple TV", "etc"]
    @Binding var selectedCategori: String
    
    var body: some View {
        HStack {
            Text("3. 카테고리")
                .font(.title)
                .padding()
            Spacer()
            Menu {
                ForEach(categoris, id: \.self) { categori in
                    Button(action: {
                        selectedCategori = categori
                    }) {
                        HStack {
                            Text(categori)
                            if selectedCategori == categori {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                Text(selectedCategori.isEmpty ? "없음" : "\(selectedCategori)")
                    .font(.title2)
                    .padding()
                    .frame(width: 200)  // 너비를 확장하여 클릭 영역 확보
                    .background(Color.gray.opacity(0.15))  // 배경색 설정
                    .cornerRadius(15)  // 모서리 둥글게
            }
        }
        .padding()
    }
}

struct ColorSelectionMenu: View {
    var colors = [
        ("빨강색", "255,0,0"),
        ("주황색", "255,165,0"),
        ("노란색", "255,255,0"),
        ("초록색", "0,128,0"),
        ("파란색", "0,0,255"),
        ("보라색", "128,0,128"),
        ("흰색", "255,255,255"),
        ("검은색", "0,0,0")
    ]
    
    @Binding var selectedColor: String
    
    var body: some View {
        HStack {
            Text("4. 색상")
                .font(.title)
                .padding()
            Spacer()
            Menu {
                ForEach(colors, id: \.0) { color in
                    Button(action: {
                        // RGB 값과 색상명을 함께 저장
                        selectedColor = "\(color.1)/\(color.0)"
                    }) {
                        HStack {
                            Text(color.0)
                            if selectedColor == "\(color.1)/\(color.0)" {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                // selectedColor에서 색상명만 분리하여 표시
                Text(selectedColor.isEmpty ? "없음" : selectedColor.components(separatedBy: "/").last ?? "없음")
                    .font(.title2)
                    .padding()
                    .frame(width: 200)  // 너비를 확장하여 클릭 영역 확보
                    .background(Color.gray.opacity(0.15))  // 배경색 설정
                    .cornerRadius(15)  // 모서리 둥글게
            }
        }
        .padding()
    }
}
struct SummaryTextField: View {
    @Binding var fieldData: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("7. 상세설명")
                .font(.title)
                .padding()
            
            TextField(text: $fieldData) {
                Text("제품에 대한 소개를 작성해주세요.")
            }
            .frame(height: 500, alignment: .topLeading)
            .frame(maxWidth: .infinity)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.gray, lineWidth: 1.5)
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        ProductUploadView()
    }
}
