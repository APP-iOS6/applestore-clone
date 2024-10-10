//
//  ProductListView.swift
//  ApplePark
//
//  Created by 강승우 on 10/7/24.
//

import SwiftUI

struct ProductListView: View {
    var product: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 107, height: 130)
            .foregroundStyle(.white)
            .overlay {
                VStack {
                    Image(product)
                        .resizable()
                        .frame(width: 70, height: 70)
                    Text(product)
                        .foregroundStyle(Color(UIColor.label))
                }
            }
    }
}

#Preview {
    ProductListView(product: "iPhone")
}
