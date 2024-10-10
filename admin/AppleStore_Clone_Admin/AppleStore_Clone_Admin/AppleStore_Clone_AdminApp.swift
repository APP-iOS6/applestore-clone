//
//  AppleStore_Clone_AdminApp.swift
//  AppleStore_Clone_Admin
//
//  Created by 김정원 on 10/7/24.
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
struct AppleStore_Clone_AdminApp: App {
    @StateObject private var authStore = AuthManager()
    @StateObject private var itemStore = ItemStore()
    @StateObject private var profileStore = ProfileStore()
    @StateObject private var orderStore = OrderStore()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(authStore)
                .environmentObject(itemStore)
                .environmentObject(profileStore)
                .environmentObject(orderStore)
        }
    }
}
