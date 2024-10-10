//
//  ProductEditView.swift
//  ApplePark
//
//  Created by 김수민 on 10/8/24.
//

import SwiftUI

struct ProductEditView: View {
    @Binding var isShowSheet: Bool
    var itemStore: ItemStore
    @Binding var item: Item
    
    @State private var newName: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $newName)
                Button(action: {
                    item.name = newName
                    Task {
                        await itemStore.updateProducts(item)
                    }
                    newName = ""
                    isShowSheet.toggle()
                }, label: {
                    Text("수정하기")
                })
            }
            .navigationTitle("Product Edit")
            
        }
        .onAppear {
            newName = item.name
            }
        }
}

//#Preview {
//    ProductEditView(isShowSheet: <#Binding<Bool>#>, itemStore: <#ItemStore#>, item: <#Binding<Item>#>)
//}
