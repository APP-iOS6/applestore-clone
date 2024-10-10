//
//  ProductDetailView.swift
//  ApplePark
//
//  Created by Hyunwoo Shin on 10/7/24.
//

import SwiftUI

struct ProductDetailView: View {
    @Binding var item: Item
    @EnvironmentObject var orderStore: OrderStore
    @EnvironmentObject var authManager: AuthManager
    @State var color: String = ""
    @State var rgbColor: [String] = ["", "", ""]
    //    let productColor: [Color] = [.red, .blue, .green]
    @State var isSelectedColor: Bool = false
    @State var isSelectedAppleCare: Bool = false
    @State var isSelectedNotAppleCare: Bool = false
    
    var body: some View {
        ZStack {
            Color(UIColor(red: 240/255, green: 238/255, blue: 247/255, alpha: 1)).ignoresSafeArea()
            
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        AsyncImage(url: URL(string: item.imageURL))
                        {
                            image in
                            
                            image.image?.resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        
                        Spacer()
                            .frame(height: 20)
                        
                        VStack(alignment: .leading) {
                            Group {
                                Text("모델")
                                    .font(.title3)
                                    .bold()
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                        Text(item.description)
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                    }
                                    .padding(15)
                                    
                                    Spacer()
                                    
                                    Text("₩\(item.price) 부터")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                    
                                    Spacer()
                                }
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.gray, lineWidth: 2)
                                )
                            }
                            
                            Spacer()
                                .frame(height: 50)
                            
                            Group {
                                HStack {
                                    Group {
                                        Text("색상 ")
                                            .font(.title3)
                                            .bold()
                                    }
                                }
                                
                                VStack {
                                    Circle()
                                        .fill(Color(UIColor(
                                            red: CGFloat((Double(rgbColor[0]) ?? 0)/255),
                                            green: CGFloat((Double(rgbColor[1]) ?? 0)/255),
                                            blue: CGFloat((Double(rgbColor[2]) ?? 0)/255),
                                            alpha: 1)))
                                        .shadow(radius: 0.8)
                                        .frame(width: 25)
                                    
                                    Text(color)
                                        .foregroundStyle(Color(UIColor.label))
                                        .font(.caption2)
                                        .frame(minWidth: 80)
                                }
                                .padding([.top, .bottom], 10)
                                .padding([.leading, .trailing], 20)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.gray, lineWidth: 2)
                                )
                            }
                            
                            Spacer()
                                .frame(height: 50)
                            
                            Group {
                                HStack {
                                    Group {
                                        Text("AppleCare+ 보증. ")
                                            .font(.title3)
                                            .bold()
                                        + Text("새로 구입한 iPhone을 보호하세요")
                                            .font(.title3)
                                    }
                                }
                                
                                VStack {
                                    Button {
                                        isSelectedAppleCare = true
                                        isSelectedNotAppleCare = false
                                    } label: {
                                        VStack(alignment: .leading) {
                                            Text("AppleCare+")
                                                .bold()
                                                .padding([.top, .leading, .trailing], 15)
                                            Text("₩\(Int((Double(item.price) ?? 0) / 10))")
                                                .padding([.leading, .trailing], 15)
                                            
                                            Divider()
                                            
                                            VStack(alignment: .leading) {
                                                Text("• 우발적인 손상에 대한 횟수 제한 없는 수리◇")
                                                
                                                Text("• Apple 정품 부품으로 진행되는 Apple 인증 수리 서비스")
                                                
                                                Text("• Apple 전문가의 우선 지원")
                                            }
                                            .padding([.bottom, .leading, .trailing], 15)
                                        }
                                        .font(.caption)
                                        .background(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .foregroundStyle(.gray)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(isSelectedAppleCare ? .blue : .gray, lineWidth: 2)
                                        )
                                    }
                                    
                                    Button {
                                        isSelectedNotAppleCare = true
                                        isSelectedAppleCare = false
                                    } label: {
                                        HStack {
                                            Text("AppleCare+ 보증 추가 안 함")
                                                .font(.caption)
                                                .padding(15)
                                                .foregroundStyle(.gray)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(.white)
                                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                                .bold()
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .stroke(isSelectedNotAppleCare ? .blue : .gray, lineWidth: 2)
                                                )
                                        }
                                    }
                                    
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("AppleCare+의 혜택은 무엇인가요?")
                                            Text("떨어뜨리거나 액체를 엎지르는 등의 우발적인 사고로부터 iPhone을 보호할 수 있습니다. 보장 내용을 살펴보세요.")
                                        }
                                        .font(.caption)
                                        .padding(15)
                                        .foregroundStyle(.gray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color(UIColor(red: 49/255, green:51/255, blue: 56/255, alpha: 0.1)))
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .bold()
                                    }
                                }
                            }
                        }
                        .padding(.leading)
                        .padding(.trailing)
                    }
                }
                
                if isSelectedAppleCare || isSelectedNotAppleCare {
                    VStack {
                        HStack {
                            Button {
                                if authManager.authenticationState != .unauthenticated {
                                    let order = Order(
                                        trackingNumber: UUID().uuidString,
                                        orderDate: Date.now,
                                        shippingAddress: "",
                                        phoneNumber: "",
                                        productName: item.name,
                                        imageURL: item.imageURL,
                                        color: color,
                                        itemId: item.itemId,
                                        hasAppleCarePlus: isSelectedAppleCare ? true : false,
                                        quantity: 1,
                                        unitPrice: item.price,
                                        bankName: "",
                                        accountNumber: "",
                                        isPay: false
                                    )
                                    
                                    Task {
                                        await orderStore.addOrder(order, userID: authManager.email)
                                    }
                                } else {
                                    Task {
                                        await authManager.signInWithGoogle()
                                    }
                                }
                            } label: {
                                HStack {
                                    Spacer()
                                    
                                    Text("장바구니에 담기")
                                    
                                    Spacer()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding([.leading, .trailing])
                }
            }
        }
        .onAppear {
            let splitStr = item.color.split(separator: "/").map { String($0) }
            let splitColor = splitStr[0].split(separator: ",")
            
            rgbColor = splitColor.map { String($0) }
            
            if splitStr.count > 1 {
                color = splitStr[1]
            }
        }
    }
}

//#Preview {
//    ProductDetailView(item: $Item(itemId: UUID().uuidString,
//                                 name: "iPhone 16 Pro Max",
//                                 category: "iPhone",
//                                 price: 1100000,
//                                 description: "디스플레이 크기 어쩌고",
//                                 stockQuantity: 8,
//                                 imageURL: "https://assets.swappie.com/cdn-cgi/image/width=600,height=600,fit=contain,format=auto/swappie-iphone-13-pro-sierra-blue-back.png?v=a58d97a7",
//                                 color: "151,32,100/메탈릭로제",
//                                 isAvailable: true))
//}

//                            ScrollView(.horizontal) {
//                                HStack {
//
//                                    ForEach(productColor, id: \.self) { color in
//                                        Button {
//                                            isSelectedColor = true
//                                        } label: {
//                                            VStack {
//                                                Circle()
//                                                    .fill(color)
//                                                    .frame(width: 25)
//
//                                                Text("아무튼 무슨색")
//                                                    .foregroundStyle(Color(UIColor.label))
//                                                    .font(.caption2)
//                                            }
//                                            .padding([.top, .bottom], 5)
//                                            .padding([.leading, .trailing], 20)
//                                            .overlay(
//                                                RoundedRectangle(cornerRadius: 5)
//                                                    .stroke(.gray, lineWidth: 1)
//                                            )
//                                        }
//                                    }
//                                }
//                            }
