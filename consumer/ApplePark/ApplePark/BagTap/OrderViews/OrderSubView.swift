//
//  OrderSubView.swift
//  ApplePark
//
//  Created by 홍지수 on 10/10/24.
//

import SwiftUI

struct OrderSubView: View {
    @State var isDelivery: Bool = true
    @State var isPickUp: Bool = false
    let filteredOrders : [Order]
    var body: some View {
        Text("우편번호")
        
        // 주문 상품 정보
        ForEach(filteredOrders.indices, id: \.self) { index in
            
            
            Section {
                HStack(alignment: .top) {
                    AsyncImage(url: URL(string: filteredOrders[index].imageURL)){ image in
                        image
                            .resizable()
                            .frame(width: 80, height: 80)
                    } placeholder: {
                        ProgressView()
                    }
                    .padding(.horizontal)
                    VStack(alignment: .leading) {
                        Text("\(filteredOrders[index].productName) ")
                        +
                        Text(filteredOrders[index].color)
                    }
                    .font(.system(size: 14, weight: .bold))
                    Spacer()
                    Text("￦\(filteredOrders[index].totalPrice)")
                        .font(.system(size: 14))
                }
                // 저거 사진이 엄청큰거같은데
                // appleCare+
                if filteredOrders[index].hasAppleCarePlus {
                    HStack(alignment: .top) {
                        Rectangle()
                            .frame(width: 80)
                            .foregroundStyle(.clear)
                            .padding(.horizontal)
                        Image("appleCare")
                            .resizable()
                            .frame(width:40, height: 40)
                        VStack(alignment: .leading) {
                            HStack(alignment: .top) {
                                Text(filteredOrders[index].productName + "를\n위한 AppleCare+")
                                    .font(.system(size: 14, weight: .bold))
                                Spacer()
                                Text("￦\(Int(filteredOrders[index].totalPrice/10))")
                                    .font(.system(size: 14))
                            }
                            
                            Text("Apple하드웨어와 함께 자동으로 등록됩니다.")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                        
                    }
                }
                
                // 사용자 체크 사항
                HStack {
                    Button {
                        isDelivery = true
                        isPickUp = false
                    } label: {
                        HStack(alignment: .center) {
                            Image(systemName: isDelivery ? "checkmark.circle.fill": "circle")
                                .foregroundColor(isDelivery ? .blue : .black)
                                .font(.system(size: 20))
                        }
                        .frame(width: 80)
                        
                    }
                    .padding()
                    VStack(alignment: .leading) {
                        Text("배송 2024/10/30 - 2024/11/06")
                            .font(.system(size: 14))
                        Text("표준 배송 - 무료 배송")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                }
//                HStack {
//                    Button {
//                        isDelivery = false
//                        isPickUp = true
//                    } label: {
//                        Image(systemName: isPickUp ? "checkmark.circle.fill": "circle")
//                            .foregroundColor(isPickUp ? .blue : .black)
//                            .font(.system(size: 20))
//                    }
//                    .padding()
//                    VStack(alignment: .leading) {
//                        Text("매장 내 픽업")
//                        Text("Apple 하남에서 픽업 불가능")
//                            .font(.footnote)
//                            .foregroundStyle(.gray)
//                    }
//                    .padding(.leading)
//                }
            }
        }
    }
}

//#Preview {
//    OrderSubView(isDelivery: true, isPickUp: false, filteredOrders: <#T##[Order]#>)
//}
