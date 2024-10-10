//
//  AccessoryListView.swift
//  ApplePark
//
//  Created by 강승우 on 10/7/24.
//

import SwiftUI

struct AccessoryListView: View {
    var accessory: String
    
    var body: some View {
        Text(accessory)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.white)
            }
    }
}

#Preview {
    AccessoryListView(accessory: "모든 액세서리")
}
