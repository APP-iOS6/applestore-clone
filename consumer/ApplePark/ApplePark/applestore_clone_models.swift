// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Foundation
import FirebaseCore
import FirebaseFirestore
import GoogleSignInSwift
@preconcurrency import FirebaseAuth
@preconcurrency import GoogleSignIn

public enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

public enum AuthenticationFlow {
    case login
    case signUp
}

enum UserRole {
    case admin      // 관리자
    case consumer   // 소비자
}



@MainActor
open class AuthManager: ObservableObject {
    @Published var name: String = "unkown"
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var flow: AuthenticationFlow = .login
    
    @Published var isValid: Bool  = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage: String = ""
    @Published var user: User?
    @Published var displayName: String = ""
    @Published var photoURL: URL?
    @Published var userID: String = ""
    @Published var itemStore: ItemStore = ItemStore()
    
    
    @Published var profileInfo: ProfileInfo = ProfileInfo(nickname: "", registrationDate: Date(), recentlyViewedProducts: [])
    @Published var role: UserRole = .consumer
    public init() {
        self.itemStore = ItemStore()
    }
}

enum AuthenticationError: Error {
    case tokenError(message: String)
}

extension AuthManager {
    func loadUserProfile(email: String) async {
        do {
            let db = Firestore.firestore()
            let snapshots = try await db.collection("User").document(email).collection("profileInfo").getDocuments()
            
            for document in snapshots.documents {
                let docData = document.data()
                let nickname: String = email
                
                let registrationTimestamp = docData["registrationDate"] as? Timestamp
                let registrationDate: Date = registrationTimestamp?.dateValue() ?? Date()
                
                let recentlyViewedProducts: [String] = docData["recentlyViewedProducts"] as? [String] ?? []
                
                self.profileInfo = ProfileInfo(
                    nickname: nickname,
                    registrationDate: registrationDate,
                    recentlyViewedProducts: recentlyViewedProducts
                )
            }
        } catch{
            print("\(error)")
        }
    }
    
    func signInWithGoogle() async -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found in Firebase configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller!")
            
            return false
        }
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            let user = userAuthentication.user
            guard let idToken = user.idToken else { throw AuthenticationError.tokenError(message: "ID token missing") }
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
            
            self.userID = firebaseUser.uid
            
            self.email = firebaseUser.email ?? ""  // 구글 로그인하면 이메일 설정
            await loadUserProfile(email: email)
            
            authenticationState = .authenticated
            return true
        }
        catch {
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
            return false
        }
    }
}

// 제품 관리
public struct Item: Codable, Sendable {
    public var itemId: String = UUID().uuidString    // 상품ID
    public  var name: String        // 상품명
    public var category: String    // 카테고리
    public var price: Int          // 가격
    public var description: String // 상세설명
    public var stockQuantity: Int  // 재고수량
    public var imageURL: String    // 이미지 URL
    public  var color: String       // 색상
    public  var isAvailable: Bool   // 상품상태(품절, 판매중 / Bool)
    
    public static let dummyData = Item(itemId: "1", name: "Dummy Item", category: "Dummy Category", price: 1000, description: "Dummy Description", stockQuantity: 10, imageURL: "https://example.com/image.jpg", color: "Dummy Color", isAvailable: true)
    public init(itemId: String, name: String, category: String, price: Int, description: String, stockQuantity: Int, imageURL: String, color: String, isAvailable: Bool) {
        self.itemId = itemId
        self.name = name
        self.category = category
        self.price = price
        self.description = description
        self.stockQuantity = stockQuantity
        self.imageURL = imageURL
        self.color = color
        self.isAvailable = isAvailable
    }
    
    // price가격을 천 단위 구분
    var formattedPrice: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = "," // 천 단위 구분
        if let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) {
            return formattedPrice
        } else {
            return "\(price)"
        }
    }
}

public struct Order: Codable, Hashable {
    var trackingNumber: String
    var orderDate: Date                // 주문 날짜
    //    var nickname: String               // 닉네임
    var shippingAddress: String        // 배송지
    var phoneNumber: String            // 전화번호
    var productName: String            // 상품명
    var imageURL: String               // 이미지 URL
    var color: String                  // 색상
    var itemId: String                // 상품ID
    
    var hasAppleCarePlus: Bool         // 애플 케어 플러스 유무
    var quantity: Int                  // 수량
    var unitPrice: Int                 // 단가
    
    var bankName: String               // 은행명
    var accountNumber: String          // 계좌번호
    
    var isPay: Bool                    // 구매한 상품(True: 구매O, False: 구매X)
    
    
    // *수량 + 애플 케어가 true라면 기존 가격에서 10% 더함
    var totalPrice: Int {
        let total = (quantity * unitPrice) + ((unitPrice/10) * quantity)
        return hasAppleCarePlus ? total : (quantity * unitPrice)
    }
    
    // 날짜 Formatter 생성
    var formattedOrder: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일 HH시 mm분"
        return formatter.string(from: orderDate)
    }
}

// 고객ID
public struct UserID: Identifiable {
    public var id: UUID = UUID() // 고객 아이디
    var order: [Order]
    var profileInfo: ProfileInfo
    
    public init(order: [Order], profileInfo: ProfileInfo) {
        self.order = order
        self.profileInfo = profileInfo
    }
}
// 고객 관리
public struct ProfileInfo: Codable, Sendable {
    var nickname: String               // 닉네임
    //  var email: String                  // 이메일
    var registrationDate: Date         // 가입날짜
    var recentlyViewedProducts: [String] // 최근 본 제품(상품 ID 리스트)
    
    //    static let dummyData = ProfileInfo(nickname: "김민수", email: "minsoo@gmail.com", registrationDate: Date(), recentlyViewedProducts: [])
    //
    public init(nickname: String,/* email: String, */ registrationDate: Date, recentlyViewedProducts: [String]) {
        self.nickname = nickname
        //      self.email = email
        self.registrationDate = registrationDate
        self.recentlyViewedProducts = recentlyViewedProducts
    }
    // 가입 날짜 Formatter 생성
    var formattedRegistration: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일 HH시 mm분"
        return formatter.string(from: registrationDate)
    }
}
public protocol ItemStoreType {
    func addProduct(_ item: Item, userID: String) async
    func updateProducts(_ item: Item) async
    func loadProducts() async
    func deleteProduct(_ item: Item, userID: String) async
}

@MainActor
open class ItemStore: ObservableObject, ItemStoreType {
    @Published public var items: [Item] = []
    public static let shared = ItemStore()
    public init() {
        //        Task {
        //            await loadProducts()
        //        }
        
    }
    
    public func addProduct(_ item: Item, userID: String) async {
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
    
    public func updateProducts(_ item: Item) async {
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
    
    public func loadProducts() async {
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
                //print("save Items: \(savedItems)")
            }
            
            self.items = savedItems
            //print("items: \(self.items)")
            
        } catch{
            print("\(error)")
        }
    }
    // MARK: 상품 삭제
    public func deleteProduct(_ item: Item, userID: String) async {
        do {
            let db = Firestore.firestore()
            
            try await db.collection("User").document(userID).collection("Item").document("\(item.itemId)").delete()
            // 컬렉션에 있는 USER 안에 Item 안에 itemId를 삭제
            print("Document successfully removed!")
            
            
            if let index = items.firstIndex(where: { $0.itemId == item.itemId }) {
                items.remove(at: index)
            }
        } catch {
            print("Error deleting document: \(error)")
        }
    }
    
    //MARK: 상품 카테고리 필터
    public func filterByCategory(items: [Item], category: String) {
        Task {
            await loadProducts()
            self.items = self.items.filter { $0.category == category }
        }
        
    }
    
    
}


@MainActor
class OrderStore: ObservableObject {
    @Published var orders: [Order] = []
    
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
    
    func loadOrder(userID: String) async {
        do {
            let db = Firestore.firestore()
            let snapshots = try await db.collection("User").document(userID).collection("Order").getDocuments()
            
            var savedOrders: [Order] = []
            
            for document in snapshots.documents {
                let id: String = document.documentID
                
                let docData = document.data()
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
                
                let order = Order(trackingNumber: trackingNumber,
                                  orderDate: orderDate,
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
                                  isPay: isPay)
                
                savedOrders.append(order)
                print("Saved Orders: \(savedOrders)")
            }
            
            self.orders = savedOrders
            print("Orders: \(self.orders)")
            
        } catch {
            print("Error loading orders: \(error)")
        }
    }
    
    func deleteOrder(_ order: Order, userID: String) async {
        do {
            let db = Firestore.firestore()
            
            // Firestore에서 해당 주문 삭제
            try await db.collection("User").document(userID).collection("Order").document("\(order.orderDate)").delete()
            print("Document successfully removed!")
            
            if let index = orders.firstIndex(where: { $0.orderDate == order.orderDate }) {
                orders.remove(at: index)
            }
        } catch {
            print("Error deleting document: \(error)")
        }
    }
    
    
}
