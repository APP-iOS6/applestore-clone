//
//  BagView.swift
//  ApplePark
//
//  Created by 홍지수 on 10/10/24.
//

import SwiftUI

struct BagView: View {
    @State var isshow: Bool = false
    
    var body: some View {
        Button {
            isshow = true
        }label: {
            Image(systemName: "bag")
        }
        .sheet(isPresented: $isshow, content: { OrderView() })
    }
}
