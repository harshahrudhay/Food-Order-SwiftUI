//
//  CartManager.swift
//  Food Order
//
//  Created by HarshaHrudhay on 15/09/25.
//

import Foundation
import SwiftUI
import Combine



class CartManager: ObservableObject {
    @Published var items: [CartItem] = []
    
    func addToCart(image: Image, name: String, description: String, price: Double) {
        if let index = items.firstIndex(where: { $0.name == name }) {
            items[index].quantity += 1
        } else {
            let newItem = CartItem(image: image, name: name, description: description, price: price, quantity: 1)
            items.append(newItem)
        }
    }
    
    func updateQuantity(for item: CartItem, change: Int) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].quantity += change
            if items[index].quantity <= 0 {
                items.remove(at: index)
            }
        }
    }
    
    func clearCart() {
        items.removeAll()
    }
}

struct CartItem: Identifiable {
    let id = UUID()
    var image: Image
    var name: String
    var description: String
    var price: Double
    var quantity: Int
}

struct CartItemCodable: Codable, Identifiable {
    let id: UUID
    let name: String
    let description: String
    let price: Double
    let quantity: Int
    
    init(from item: CartItem) {
        self.id = item.id
        self.name = item.name
        self.description = item.description
        self.price = item.price
        self.quantity = item.quantity
    }
    
    func toCartItem() -> CartItem {
        return CartItem(
            image: Image(systemName: "cart"),
            name: name,
            description: description,
            price: price,
            quantity: quantity
        )
    }
}
