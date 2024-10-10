//
//  ItemStoreType.swift
//  ApplePark
//
//  Created by Soom on 10/8/24.
//

import Foundation

protocol ItemStoreType {
    func addProduct(_ item: Item, userID: String) async
    func updateProducts(_ item: Item) async
    func loadProducts() async
    func deleteProduct(_ item: Item) async
}
