//
//  OrderStore.swift
//  ApplePark
//
//  Created by 김종혁 on 10/8/24.
//

import Foundation
import Observation
import FirebaseCore
import FirebaseFirestore

@MainActor
class OrderStore: ObservableObject {
    @Published var orders: [Order] = []
    
    init () {
        Task {
            await loadAllOrders()
        }
    }
    
    func addOrder(_ order: Order, userID: String) async {
        orders.append(order)
        
        do {
            let db = Firestore.firestore()
            
            try await db.collection("User").document(userID).collection("Order").document("\(order.orderDate)").setData([
                "trackingNumber": order.trackingNumber,
                "orderDate": Timestamp(date: order.orderDate),
                "shippingAddress": order.shippingAddress,
                "phoneNumber": order.phoneNumber,
                "productName": order.productName,
                "imageURL": order.imageURL,
                "color": order.color,
                "itemId": order.itemId,
                "hasAppleCarePlus": order.hasAppleCarePlus,
                "quantity": order.quantity,
                "unitPrice": order.unitPrice,
                "bankName": order.bankName,
                "accountNumber": order.accountNumber,
                
                "isPay": order.isPay
            ])
            
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
//    func updateOrder(_ order: Order, for userID: String) async {
//        do {
//            let db = Firestore.firestore()
//            try await db.collection("User").document(userID).collection("Order").document("\(order.orderDate)").setData([
//                "trackingNumber": order.trackingNumber,
//                "orderDate": Timestamp(date: order.orderDate),
//                "shippingAddress": order.shippingAddress,
//                "phoneNumber": order.phoneNumber,
//                "productName": order.productName,
//                "imageURL": order.imageURL,
//                "color": order.color,
//                "itemId": order.itemId,
//                "hasAppleCarePlus": order.hasAppleCarePlus,
//                "quantity": order.quantity,
//                "unitPrice": order.unitPrice,
//                "bankName": order.bankName,
//                "accountNumber": order.accountNumber
//            ])
//            print("Document successfully written!")
//        } catch {
//            print("Error writing document: \(error)")
//        }
//        for (index, updateOrder) in orders.enumerated() {
//            if updateOrder.itemId == order.itemId {
//                orders[index] = order
//            }
//        }
//    }
    
    func loadAllOrders() async {
        orders.removeAll()
        
        do {
            let db = Firestore.firestore()
            let users = try await db.collection("User").getDocuments()
            
            for user in users.documents {
                let userID = user.documentID
                print(userID)
                await loadSpecificUserOrders(userID: userID)
            }
            
            print("Orders: \(self.orders)")
        } catch {
            print("Error loading orders: \(error)")
        }
    }
    
    private func loadSpecificUserOrders(userID: String) async {
        do {
            let db = Firestore.firestore()
            let orders = try await db.collection("User").document(userID).collection("Order").getDocuments()
            
            for order in orders.documents {
                let id = order.documentID
                let docData = order.data()
                let trackingNumber: String = docData["trackingNumber"] as? String ?? ""
                let orderDate: Date = (docData["orderDate"] as? Timestamp)?.dateValue() ?? Date()
                let shippingAddress: String = docData["shippingAddress"] as? String ?? ""
                let phoneNumber: String = docData["phoneNumber"] as? String ?? ""
                let productName: String = docData["productName"] as? String ?? ""
                let imageURL: String = docData["imageURL"] as? String ?? ""
                let color: String = docData["color"] as? String ?? ""
                let itemId: String = docData["itemId"] as? String ?? ""
                let hasAppleCarePlus: Bool = docData["hasAppleCarePlus"] as? Bool ?? false
                let quantity: Int = docData["quantity"] as? Int ?? 0
                let unitPrice: Int = docData["unitPrice"] as? Int ?? 0
                let bankName: String = docData["bankName"] as? String ?? ""
                let accountNumber: String = docData["accountNumber"] as? String ?? ""
                let isPay: Bool = docData["isPay"] as? Bool ?? false
                
                let order = Order(userID: id,
                                  trackingNumber: trackingNumber,
                                  orderDate: orderDate,
                                  nickname: "Test Nickname",
                                  shippingAddress: shippingAddress,
                                  phoneNumber: phoneNumber,
                                  productName: productName,
                                  imageURL: imageURL,
                                  color: color,
                                  itemId: itemId,
                                  hasAppleCarePlus: hasAppleCarePlus,
                                  quantity: quantity,
                                  unitPrice: unitPrice,
                                  bankName: bankName,
                                  accountNumber: accountNumber,
                                  isPay: isPay,
                                  deliveryStatus: DeliveryStatus.processing.rawValue)
                
                self.orders.append(order)
            }
        } catch {
            print("Error loading specific user orders: \(error)")
        }
    }
    
    func deleteOrder(_ order: Order, userID: String) async {
        do {
            let db = Firestore.firestore()
            
            // Firestore에서 해당 주문 삭제
            try await db.collection("User").document(userID).collection("Order").document("\(order.orderDate)").delete()
            print("Document successfully removed!")
            
            if let index = orders.firstIndex(where: { $0.id == order.id }) {
                orders.remove(at: index)
            }
        } catch {
            print("Error deleting document: \(error)")
        }
    }
}


