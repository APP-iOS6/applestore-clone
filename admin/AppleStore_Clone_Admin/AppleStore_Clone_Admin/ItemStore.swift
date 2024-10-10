//
//  ItemStore.swift
//  ApplePark
//
//  Created by 김수민 on 10/7/24.
//


import Foundation
import Observation
import FirebaseCore
import FirebaseFirestore


@MainActor
class ItemStore: ObservableObject, ItemStoreType {
    
    @Published private(set) var items: [Item] = []
    
    func filterItems(for category: ProductType) -> [Item] {
        return items.filter { $0.category == category.rawValue }
    }
    
    func addProduct(_ item: Item, userID: String) async {
        items.append(item)
        
        do {
            let db = Firestore.firestore()
            
            // userID 찍힘..
            print("userID: \(userID), itemId: \(item.itemId)")
            
            try await db.collection("Item").document("\(item.itemId)").setData([
                "name": item.name,
                "category": item.category,
                "color": item.color,
                "description": item.description,
                "imageURL": item.imageURL,
                
                "price": item.price,
                "stockQuantity": item.stockQuantity,
                
                "isAvailable": item.isAvailable,
            ])
            
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
    func updateProducts(_ item: Item) async {
        do {
            let db = Firestore.firestore()
            try await db.collection("Item").document("\(item.itemId)").setData([
                "name": item.name,
                "category": item.category,
                "color": item.color,
                "description": item.description,
                "imageURL": item.imageURL,
                
                "price": item.price,
                "stockQuantity": item.stockQuantity,
                
                "isAvailable": item.isAvailable,
            ])
            
            
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
        for (index, updateItem) in items.enumerated() {
            if updateItem.itemId == item.itemId {
                items[index].name = item.name
                items[index].category = item.category
                items[index].color = item.color
                items[index].description = item.description
                items[index].imageURL = item.imageURL
                
                items[index].price = item.price
                items[index].stockQuantity = item.stockQuantity
                
                items[index].isAvailable = item.isAvailable
                
            }
        }
    }
    func loadProducts() async {
        do{
            let db = Firestore.firestore()
            let snapshots = try await db.collection("Item").getDocuments()
            
            var savedItems: [Item] = []
            
            for document in snapshots.documents {
                let id: String = document.documentID
                
                let docData = document.data()
                let name: String = docData["name"] as? String ?? ""
                let category: String = docData["category"] as? String ?? ""
                let color: String = docData["color"] as? String ?? ""
                let description: String = docData["description"] as? String ?? ""
                let imageURL: String = docData["imageURL"] as? String ?? ""
                
                
                let price: Int = docData["price"] as? Int ?? 0
                let stockQuantity: Int = docData["stockQuantity"] as? Int ?? 0
                
                let isAvailable: Bool = docData["isAvailable"] as? Bool ?? true
                let item: Item = Item(itemId: id,name: name, category: category, price: price, description: description, stockQuantity: stockQuantity, imageURL: imageURL, color: color, isAvailable: isAvailable)
                
                savedItems.append(item)
                print("save Items: \(savedItems)")
            }
            
            self.items = savedItems
            print("items: \(self.items)")
            
        } catch{
            print("\(error)")
        }
    }
    func deleteProduct(_ item: Item) async {
        do {
            let db = Firestore.firestore()
            
            try await db.collection("Item").document("\(item.itemId)").delete()
            // 컬렉션에 있는 USER 안에 Item 안에 itemId를 삭제
            print("Document successfully removed!")
            
            
            if let index = items.firstIndex(where: { $0.itemId == item.itemId }) {
                items.remove(at: index)
            }
        } catch {
            print("Error deleting document: \(error)")
        }
    }
}


