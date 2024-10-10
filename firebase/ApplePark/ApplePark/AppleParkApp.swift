//
//  AppleParkApp.swift
//  ApplePark
//
//  Created by 박준영 on 10/7/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct AppleParkApp: App {
    @StateObject private var authStore = AuthManager()
    @StateObject private var itemStore = ItemStore()
    @StateObject private var orderStore = OrderStore()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(authStore)
                .environmentObject(itemStore)
                .environmentObject(orderStore)
        }
    }
}
