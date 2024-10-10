//
//  ProductCategoryView.swift
//  ApplePark
//
//  Created by 홍지수 on 10/7/24.
//

import SwiftUI

struct ProductCategoryView: View {
    @StateObject var itemStore: ItemStore = .init()
    
    var category: String
    var lineLimit: Int = 2
    @State private var isExpanded = false
    // 현재 보여지는 텍스트 인덱스
    @State private var currentIndex = 0
    @State private var opacity = 1.0
    
    @State var filteredItems: [Item] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                // 상단 가로 스크롤 뷰
                ScrollView(.horizontal, showsIndicators: false, content:  {
                    HStack {
                        Image("iphone")
                            .resizable()
                            .frame(width: 330, height: 500)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerSize: .init(width: 14, height: 14)))
                            .padding(.leading)
                        ForEach(0..<10) { index in
                            Image("iphone")
                                .resizable()
                                .frame(width: 330, height: 500)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerSize: .init(width: 14, height: 14)))
                        }
                        .padding(2)
                        Image("iphone")
                            .resizable()
                            .frame(width: 320, height: 500)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerSize: .init(width: 14, height: 14)))
                            .padding(.trailing)
                    }
                })
                //.padding(.leading)
                .scrollTargetBehavior(.paging)
                .shadow(radius: 10, y: 10)
                
                // 중간 텍스트
                
                Divider()
                    .padding([.top, .leading, .trailing])
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 80)
                    .overlay (
                        VStack {
                            HStack {
                                Text(titleTextOnes[currentIndex])
                                    .font(.footnote)
                                    .bold()
                                    .opacity(opacity)
                                Spacer()
                            }.padding(.leading)
                            HStack {
                                Text(categoryTextOnes[currentIndex])
                                    .font(.caption)
                                    .opacity(opacity)
                                Spacer()
                            }.padding(.leading)
                        }
                    )
                    .onAppear {
                        // 타이머를 설정하여 3초마다 애니메이션 실행
                        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                            withAnimation(.easeInOut(duration: 1.0)) {
                                opacity = 0.0
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                currentIndex = (currentIndex + 1) % categoryTextOnes.count
                                
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    opacity = 1.0
                                }
                            }
                        }
                    }
                Divider()
                    .padding([.top, .leading, .trailing])
                
                
                
                // 제품들 -> 상세 페이지
                ForEach(itemStore.items.indices, id: \.self) { index in
                    NavigationLink(destination: ProductDetailView(item: $itemStore.items[index])) {
                        VStack {
                            AsyncImage(url: URL(string : itemStore.items[index].imageURL)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 130, height: 150)
                            Text("New")
                                .foregroundStyle(.orange)
                                .font(.footnote)
                                .padding(.top)
                            Text(itemStore.items[index].name)
                                .font(.title2)
                                .foregroundStyle(.black)
                                .bold()
                            Text("￦ \(itemStore.items[index].price)부터")
                                .foregroundStyle(.blue)
                        }
                        .padding(40)
                    }
                }
                
                // 고정된 하단 뷰
                VStack {
                    Text(categoryTextTwo)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .lineLimit(isExpanded ? nil : 2) // 텍스트가 확장되었을 때는 모든 줄을 표시, 그렇지 않으면 2줄만 표시
                        .padding([.leading, .trailing], 20)
                        .multilineTextAlignment(.leading)
                    
                    // 더 읽어보기 버튼
                    HStack {
                        Spacer()
                        ZStack {
                            Text(categoryTextTwo)
                                .font(.system(size: 13))
                                .foregroundStyle(Color.gray)
                                .padding()
                                .lineLimit(isExpanded ? nil : lineLimit)
                            
                            if(!isExpanded) {
                                HStack {
                                    Spacer()
                                    Text("더 읽어보기")
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 0)
                                        .font(.system(size: 13))
                                        .foregroundStyle(.blue)
                                        .underline()
                                        .onTapGesture {
                                            self.isExpanded.toggle()
                                        }
                                        .background {
                                            Rectangle()
                                                .foregroundStyle(Color(.systemGray6))
                                                .blur(radius: 2)
                                        }
                                }
                                .offset(y:7.5)
                                .padding()
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6)) // 회색 배경
                
            }
            .navigationTitle(category)
        }
        .onAppear {
            itemStore.filterByCategory(items: itemStore.items, category: category)
        }
    }
}

#Preview {
    ProductCategoryView(category: "")
}
