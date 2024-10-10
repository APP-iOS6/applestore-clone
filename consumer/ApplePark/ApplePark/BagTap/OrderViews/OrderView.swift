//
//  OrderView.swift
//  ApplePark
//
//  Created by 홍지수 on 10/8/24.
//

import SwiftUI

struct OrderView: View {
    // 액션 시트
    @State private var showConfirmationDialog = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var orderStore: OrderStore
    @EnvironmentObject var authManager: AuthManager
    
    // 사용자 배송 정보
    @State var isDelivery: Bool = true
    @State var isAgree: Bool = false
    
    // 주문 알럿
    @State private var isAlert = false
    
    @State private var tempAddress: String = ""
    @State private var tempbankName: String = ""
    @State private var tempaccountNumber: String = ""
    var body: some View {
        
        NavigationStack {
//            let filteredOrders = sampleOrders.filter { $0.nickname == "john_doe" }
            let totalPrice = orderStore.orders.reduce(0) { $0 + $1.totalPrice }
            List {
                OrderSubView(filteredOrders: orderStore.orders)
                
                //MARK: - 배송 주소 및 결제 정보 입력 + 기타
                HStack(alignment: .top) {
                    navigationBarTitle("배송 주소")
                        .foregroundStyle(.gray)
                    TextField("배송 주소를 입력하세요.", text: $tempAddress)
                        .onChange(of: tempAddress) {
                            for index in orderStore.orders.indices {
                                orderStore.orders[index].shippingAddress = tempAddress
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.footnote)
                }
                .font(.footnote)
                HStack(alignment: .top) {
                    navigationBarTitle("결제")
                        .foregroundStyle(.gray)
                    VStack {
                        TextField("은행명을 입력하세요.", text: $tempbankName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.footnote)
                            .onChange(of: tempbankName) {
                                for index in orderStore.orders.indices {
                                    orderStore.orders[index].bankName = tempbankName
                                    orderStore.orders[index].accountNumber = tempaccountNumber
                                }
                            }
                        TextField("계좌번호를 입력하세요.", text: $tempaccountNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.footnote)
                    }
                }
                
                // 요약 및 기타 내용
                HStack(alignment: .top) {
                    navigationBarTitle("요약")
//                    Text("요약")
//                        .foregroundStyle(.gray)
                    VStack {
                        HStack(alignment: .center) {
                            Text("장바구니 소계")
//                                .padding(.leading)
                            Spacer()
                            Text("￦\(totalPrice)")
                        }
                        HStack(alignment: .center) {
                            Text("무료배송")
//                                .padding(.leading)
                            Spacer()
                            Text("￦0")
                        }
                        .padding(.vertical, 3)
                        Divider()
                        HStack(alignment: .center) {
                            Text("총 주문")
//                                .padding(.leading)
                            Spacer()
                            Text("￦\(totalPrice)")
                        }
                    }
                    .font(.system(size: 13, weight: .bold))
                }
                
//MARK: - 세부 정보
                
                VStack(alignment: .leading) {
                    Text("아래에서 계속 진행하도록 선택하시면 AppleCare+ 이용 약관 에 동의 하시게 되고, Apple 모바일기기보험 요약 설명서 의 내용을 읽었으며, 이용 약관, Apple모바일기기보험 요약 설명서, 플랜 확인서를 포함하여 플랜과 관련한 모든 문서를 전자 방식으로 받아서 보는 것을 확인하고 이에 동의하시게 됩니다.")
                        .foregroundStyle(.gray)
                        .font(.footnote)
                        .padding(.bottom)
                    Text("Apple 개인정보 취급방침\nAppleCare+ 이용 약관\nApple모바일기기보험 요약 설명서(Product Disclosure Statement)")
                        .foregroundStyle(.blue)
                        .font(.footnote)
                    HStack {
                        Button {
                            isAgree.toggle()
                        } label : {
                            Image(systemName: isAgree ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(isAgree ? .blue : .black)
                                .font(.system(size: 20))
                        }
                        Text("동의함")
                    }
                    .padding([.top, .bottom])
                    
                    Divider()
                    
                    Text("'주문하기'를 탭하면 Apple의 판매 및 환불 정책과 개인정보 취급방침의 모든 약관에 동의하는 것으로 간주됩니다.\n\n\n'주문하기'를 탭하면 이니시스를 통해 결제가 진행됩니다. 결제가 승인된 후에는 Apple Store 앱으로 돌아갑니다.")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .padding([.top, .bottom])
                    
                    HStack {
                        Spacer()
                        Button {
                            print("")
                        } label : {
                            Text("자주 묻는 질문")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                                .frame(width: 130, height: 30)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        
                        Button {
                            print("")
                        } label : {
                            Text("Apple에 문의")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                                .frame(width: 130, height: 30)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        Spacer()
                    }
                    .padding()
                    
                    VStack(alignment: .center) {
                        Divider()
                        Text("Apple 판매 및 환불 정책\n")
                            .padding(.vertical)
                        Text("Apple 개인정보 취급방침\n\n")
                        Text("Copyright @ 2024 Apple Inc. 모든 권리 보유.")
                            .padding(.vertical)
                            .foregroundStyle(.gray)
                    }
                    .font(.footnote)
                }
            }
//MARK: - 툴바 및 액션
            
            .padding(.horizontal, -20)
            .padding(.vertical, -10)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        showConfirmationDialog = true
                    } label: {
                        Text("취소")
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("결제")
                        .font(.headline)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("주문") {
                        if isAgree {
                            
                        } else {
                            isAlert = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
//            .CustomAlertView(isPresented: $isAlert)
            .confirmationDialog("주문이 완료되지 않은 상태에서 결제를 취소하시겠습니까?", isPresented: $showConfirmationDialog) {
                Button("결제 취소", role: .destructive) {
                    presentationMode.wrappedValue.dismiss()  // 결제 취소 시 전 화면으로 돌아가기
                }
                Button("결제 계속", role: .cancel) {
                    // 결제 계속 시 아무 동작도 하지 않음 (기존 창 유지)
                }
            } message: {
                Text("결제 취소를 원하시면 '결제 취소'를 선택하세요.")
            }
        }
    }
    
}

extension OrderView {
    
    @ViewBuilder
    func navigationBarTitle(_ title: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.gray)
                .font(.system(size:12))
                Spacer()
        }
            .frame(width: 80)
            .padding(.horizontal)
    }
}

#Preview {
    OrderView()
}
