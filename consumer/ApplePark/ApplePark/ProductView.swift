//
//  ProductView.swift
//  ApplePark
//
//  Created by Hyunwoo Shin on 10/7/24.
//

import SwiftUI

struct ProductView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var isPresented: Bool = false
    @State private var isTruncated: Bool? = nil
    @State private var isExpended: Bool = false
    @State private var scrollPosition: CGPoint = .zero
    
    private var lineLimit: Int = 2
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                VStack {
                    ScrollView {
                        HStack {
                            Text("제품")
                                .font(.system(size: 32, weight: .bold))
                            Spacer()
                            
                            Button {
                                if authManager.authenticationState == .unauthenticated {
                                    Task {
                                        await authManager.signInWithGoogle()
                                    }
                                }
                            } label: {
                                VStack{
                                    Image(systemName: "person.circle")
                                        .font(.system(size: 32, weight: .bold))
                                    Text(authManager.authenticationState == .unauthenticated ? "Login" : "Logout")
                                        .font(.caption2)
                                }
                            }
                            
                        }
                        .padding()
                        .background(GeometryReader { geometry in
                            Color.clear
                                .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                        })
                        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                            self.scrollPosition = value
                        }
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(products, id:\.self) { product in
                                    NavigationLink {
                                        ProductCategoryView(category: product)
                                    } label: {
                                        ProductListView(product: product)
                                    }
                                }
                            }
                            .padding()
                        }
                        .scrollIndicators(.hidden)
                        
                        Section(header: publicHeaderView("액세서리")) {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(accessories, id:\.self) { accessory in
                                        AccessoryListView(accessory: accessory)
                                    }
                                }
                                .padding()
                            }
                            .scrollIndicators(.hidden)
                        }
                        
                        Section(header: publicHeaderView("새로운 소식")) {
                            
                            ForEach(newTidingPhones, id:\.self) { phone in
                                Image(phone)
                                    .resizable()
                                    .frame(width: proxy.size.width * 0.9, height: proxy.size.height * 0.8)
                            }
                            
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(newTidings, id:\.self) { tiding in
                                        Image(tiding)
                                            .resizable()
                                            .frame(width: proxy.size.width * 0.9, height: proxy.size.height * 0.8)
                                        
                                    }
                                }
                                .padding()
                            }
                            .scrollIndicators(.hidden)
                        }
                        
                        Section(header: publicHeaderView("Apple Store 찾기")) {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(appleStores, id:\.self) { appleStore in
                                        Image(appleStore)
                                            .resizable()
                                            .frame(width:proxy.size.width * 0.85, height: proxy.size.height * 0.55)
                                        
                                    }
                                }
                                .padding()
                            }
                            .scrollIndicators(.hidden)
                        }
                        
                        Button {
                            // Apple Store 찾는 뷰 연결?
                        } label : {
                            HStack {
                                Text("Apple Store 찾기")
                                    .bold()
                                
                                Image(systemName: "chevron.right")
                                Spacer()
                            }
                            .font(.system(size: 18))
                            .foregroundStyle(.black)
                            .padding()
                        }
                        
                        ZStack {
                            Text(serviceInfoText)
                                .font(.system(size: 13))
                                .foregroundStyle(Color.gray)
                                .padding()
                                .lineLimit(isExpended ? nil : lineLimit)
                            
                            if(!isExpended) {
                                HStack {
                                    Spacer()
                                    Text("더 읽어보기")
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 0)
                                        .font(.system(size: 13))
                                        .foregroundStyle(.blue)
                                        .underline()
                                        .onTapGesture {
                                            self.isExpended.toggle()
                                        }
                                        .background {
                                            Rectangle()
                                                .foregroundStyle(.productTapBG)
                                                .blur(radius: 2)
                                        }
                                }
                                .offset(y:7.5)
                                .padding()
                            }
                        }
                        
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                .background(.productTapBG)
            }
            .coordinateSpace(name: "scroll")
            .navigationTitle(scrollPosition.y < 0 ? "제품" : "")
            .toolbarTitleDisplayMode(.large)
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}

#Preview {
    ProductView()
}
