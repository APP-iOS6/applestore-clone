//
//  StatisticsView.swift
//  AppleStore_Clone_Admin
//
//  Created by 김정원 on 10/7/24.
//

import SwiftUI
import Charts

enum StatisticsOption: String, CaseIterable, Identifiable {
    case productType = "기종별"
    case month = "월별"
    
    var id: String { self.rawValue }
}

struct ProductSalesData: Identifiable {
    var id = UUID()
    var productType: ProductType
    var salesAmount: Double
}
struct MonthlySalesData: Identifiable {
    var id = UUID()
    var month: String
    var salesAmount: Double
}
// 3. 더미 매출 데이터
let dummyProductSalesData: [ProductSalesData] = [
    ProductSalesData(productType: .iPhone, salesAmount: 5000000),
    ProductSalesData(productType: .AppleWatch, salesAmount: 1500000),
    ProductSalesData(productType: .iPad, salesAmount: 3000000),
    ProductSalesData(productType: .Mac, salesAmount: 4000000),
    ProductSalesData(productType: .AirPods, salesAmount: 2000000),
    ProductSalesData(productType: .AppleTV, salesAmount: 800000),
    ProductSalesData(productType: .etc, salesAmount: 500000)
]
let dummyMonthlySalesData: [MonthlySalesData] = [
    MonthlySalesData(month: "1월", salesAmount: 4000000),
    MonthlySalesData(month: "2월", salesAmount: 3500000),
    MonthlySalesData(month: "3월", salesAmount: 4500000),
    MonthlySalesData(month: "4월", salesAmount: 3000000),
    MonthlySalesData(month: "5월", salesAmount: 5000000),
    MonthlySalesData(month: "6월", salesAmount: 5500000),
    MonthlySalesData(month: "7월", salesAmount: 6000000),
    MonthlySalesData(month: "8월", salesAmount: 6500000),
    MonthlySalesData(month: "9월", salesAmount: 7000000),
    MonthlySalesData(month: "10월", salesAmount: 7500000),
    MonthlySalesData(month: "11월", salesAmount: 8000000),
    MonthlySalesData(month: "12월", salesAmount: 8500000)
]
// 4. 차트 뷰
struct StatisticsView: View {
    
    @State private var selectedOption: StatisticsOption = .productType
    
    var productSalesData: [ProductSalesData]
    var monthlySalesData: [MonthlySalesData]
    
    var body: some View {
        VStack {
            // Picker 추가
            Picker("통계 옵션 선택", selection: $selectedOption) {
                ForEach(StatisticsOption.allCases) { option in
                    Text(option.rawValue)
                        .tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // 선택된 옵션에 따라 차트 표시
            if selectedOption == .productType {
                Text("각 기종별 매출액")
                    .font(.title)
                    .padding(.top)
                
                Chart {
                    ForEach(productSalesData) { data in
                        BarMark(
                            x: .value("제품 유형", data.productType.rawValue),
                            y: .value("매출액", data.salesAmount)
                        )
                        .annotation(position: .top) {
                            Text("₩\(Int(data.salesAmount))")
                                .font(.caption)
                        }
                        .foregroundStyle(by: .value("제품 유형", data.productType.rawValue))
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXAxisLabel("제품 유형")
                .chartYAxisLabel("매출액")
                .padding()
            } else {
                Text("월별 매출액")
                    .font(.title)
                    .padding(.top)
                
                Chart {
                    ForEach(monthlySalesData) { data in
                        BarMark(
                            x: .value("월", data.month),
                            y: .value("매출액", data.salesAmount)
                        )
                        .annotation(position: .top) {
                            Text("₩\(Int(data.salesAmount))")
                                .font(.caption)
                        }
                        .foregroundStyle(by: .value("월", data.month))
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXAxisLabel("월")
                .chartYAxisLabel("매출액")
                .padding()
            }
            
            Spacer()
        }
        .navigationTitle("통계")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        StatisticsView(productSalesData: dummyProductSalesData, monthlySalesData: dummyMonthlySalesData)
    }
}
