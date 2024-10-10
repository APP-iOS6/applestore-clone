//
//  BagView.swift
//  ApplePark
//
//  Created by Mac on 10/8/24.
//

import SwiftUI

struct CartItem: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var price: Int
    var imageURL: String
    var appleCarePrice: Int?
}

struct BagView: View {
    @EnvironmentObject var orderStore: OrderStore
    @EnvironmentObject var authManager: AuthManager
    
    @State private var totalPrice: Int = 0
    @State private var isPresented: Bool = false
    
    private var vat: Int {
        return Int(Double(totalPrice) * 0.1)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if orderStore.orders.isEmpty {
                    BagViewEmpty()
                } else {
                    ScrollView {
                        ForEach(orderStore.orders, id: \.self) { order in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(alignment: .top) {
                                    AsyncImage(url: URL(string: order.imageURL)) { image in
                                        image.image?.resizable()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                    .frame(width: 40, height: 40)
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        HStack {
                                            Text(order.productName)
                                                .font(.subheadline)
                                                .fontWeight(.black)
                                                .padding(.bottom, 20)
                                            Spacer()
                                            
                                            Text("₩\(order.unitPrice)")
                                                .font(.subheadline)
                                                .padding(.bottom, 20)
                                                .offset(y: -10)
                                        }
                                        Text("오늘 주문 시, 배송:")
                                            .font(.subheadline)
                                        Text("2024/10/30 - 2024/11/06 - 무료 배송")
                                      
                                        Divider()
                                        
                                        if order.hasAppleCarePlus {
                                            HStack {
                                                AsyncImage(url: URL(string: "https://i.namu.wiki/i/6NoxTjdTjEhd9CmpflEqYmvyM1Fcp7X73xRNMENqTXkGde04Vplvu0RkrRRLEW3I5oc8Xsj8ezTehBe2eJaVGg.webp")) { image in
                                                    image.image?.resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                }
                                                .frame(width: 40, height: 40)
                                                .offset(y: -15)
                                                VStack(alignment: .leading) {
                                                    Text("iPhone 16 Pro Max를 위한 AppleCare+")
                                                        .font(.subheadline)
                                                        .bold()
                                                        .fixedSize(horizontal: false, vertical: true)
                                                        .padding(.top, 20)
                                                        .padding(.bottom, 5)
                                                        .bold()
                                                    Text("Apple하드웨어와 함께 자동으로 등록됩니다.")
                                                        .font(.subheadline)
                                                        .foregroundColor(.gray)
                                                }
                                                Spacer()
                                                
                                                VStack(alignment: .trailing) {
                                                    Text("₩\(Int((Double(order.unitPrice) ?? 0) / 10))")
                                                        .font(.caption)
                                                        .foregroundColor(.black)
                                                        .offset(y: -15)
                                                    Button(action: {
                                                    }) {
                                                        Text("제거")
                                                            .font(.caption)
                                                            .foregroundColor(.blue)
                                                            .offset(y: -15)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        }
                    }
                }
                
                Spacer()
                
                // 장바구니 총 가격 표시
                VStack(alignment: .leading) {
                    Divider()
                    HStack {
                        Text("장바구니 소계")
                            .font(.subheadline)
                        Spacer()
                        Text("₩\(totalPrice)")
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
//                    HStack {
//                        Text("다음 부가가치세 포함")
//                            .font(.subheadline)
//                        Spacer()
//                        Text("₩\(vat)")
//                            .font(.subheadline)
//                    }
//                    .padding(.horizontal, 20)
                    HStack {
                        Text("무료 배송 혜택을 이용할 수 있는 장바구니입니다.")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
                .background(Color.white)
                .padding(.bottom, 20) // 여백 추가
                
            }
            .background(Color(red: 243 / 255, green: 242 / 255, blue: 248 / 255))
            .navigationTitle("장바구니")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresented = true
                    }) {
                        Text("결제")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 76, height: 34)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .onAppear {
            if authManager.authenticationState != .unauthenticated {
                Task {
                    await orderStore.loadOrder(userID: authManager.email)
                    
                    print("\(orderStore.orders[0].totalPrice)")
                    print("\(orderStore.orders[1].totalPrice)")
                    
                    totalPrice = orderStore.orders.reduce(0) { $0 + $1.totalPrice }
                }
            }
        }
        .sheet(isPresented: $isPresented) {
            OrderView()
        }
    }
}

struct BagViewEmpty: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 10) {
                    Image(systemName: "bag")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                        .padding(.bottom, 15)
                        .padding(.top, 80)
                    
                    Text("장바구니가 비어 있습니다.")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("계속 Apple Store를 둘러보거나 이전에 저장해둔 제품을 구입하세요.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                // 모든 관심 제품 섹션
                HStack(spacing: 10) {
                    Text("모든 관심 제품")
                        .font(.title2)
                        .padding(.leading, 30)
                        .bold()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(0..<5) { index in
                            VStack(alignment: .leading) {
                                VStack(spacing: 5) {
                                    HStack {
                                        Text("New")
                                            .font(.caption)
                                            .foregroundColor(.yellow)
                                            .padding(.leading, 110)
                                            .padding(.top, 20)
                                            .padding(.bottom, -10)
                                        Spacer()
                                    }
                                    HStack(spacing: 0) {
                                        AsyncImage(url: URL(string: "https://assets.swappie.com/cdn-cgi/image/width=600,height=600,fit=contain,format=auto/swappie-iphone-13-pro-sierra-blue-back.png?v=a58d97a7")) { image in
                                            image.image?.resizable()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                        .frame(width: 80, height: 80)
                                        .padding(.trailing, 10)
                                        
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text("iPhone 16 128GB 화이트")
                                                .font(.headline)
                                            
                                            Text("₩1,250,000")
                                                .font(.subheadline)
                                                .padding(.bottom, 10)
                                            
                                            Button(action: {
                                            }) {
                                                Text("세부 정보 보기")
                                                    .font(.caption)
                                                    .foregroundColor(.blue)
                                                    .padding(.bottom, 10)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    
                                    HStack {
                                        Button(action: {
                                        }) {
                                            Text("계속")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 30)
                                                .padding(.vertical, 8)
                                                .background(Color.blue)
                                                .cornerRadius(20)
                                                .padding(.leading, 110)
                                                .offset(y: -10)
                                                .padding(.bottom, 10)
                                            Spacer()
                                        }
                                    }
                                }
                                Divider()
                            }
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
            .background(Color(red: 243 / 255, green: 242 / 255, blue: 248 / 255))
            .navigationTitle("장바구니")
        }
    }
}


#Preview {
    BagViewEmpty()
}
