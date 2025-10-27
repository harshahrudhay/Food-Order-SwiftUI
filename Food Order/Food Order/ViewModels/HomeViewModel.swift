//
//  HomeViewModel.swift
//  Food Order
//
//  Created by HarshaHrudhay on 15/09/25.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var cart: [UUID: Int] = [:]
    @Published var orders: [CartDisplayItem] = []
    
    let cakes = [
        FoodItem(name: "Chocolate Cake", imageName: "cake", price: "$8"),
        FoodItem(name: "Vanilla Cake", imageName: "cake", price: "$7"),
        FoodItem(name: "Red Velvet", imageName: "cake", price: "$9"),
        FoodItem(name: "Apple Cake", imageName: "cake", price: "$7"),
        FoodItem(name: "Cool Cake", imageName: "cake", price: "$9")
    ]
    
    let shakes = [
        FoodItem(name: "Strawberry Shake", imageName: "milkshake", price: "$5"),
        FoodItem(name: "Chocolate Shake", imageName: "milkshake", price: "$6"),
        FoodItem(name: "Banana Shake", imageName: "milkshake", price: "$4"),
        FoodItem(name: "BlueBerry Shake", imageName: "milkshake", price: "$6"),
        FoodItem(name: "Vanilla Shake", imageName: "milkshake", price: "$4")
    ]
    
    let sweets = [
        FoodItem(name: "Gulab Jamun", imageName: "sweets", price: "$3"),
        FoodItem(name: "Rasgulla", imageName: "sweets", price: "$4"),
        FoodItem(name: "Jalebi", imageName: "sweets", price: "$2"),
        FoodItem(name: "Rasmalai", imageName: "sweets", price: "$4"),
        FoodItem(name: "Laddu", imageName: "sweets", price: "$2")
    ]
    
    let pizza = [
        FoodItem(name: "Italian pizza", imageName: "pizza", price: "$15"),
        FoodItem(name: "Pepporoni pizza", imageName: "pizza", price: "$18"),
        FoodItem(name: "Chicken pizza", imageName: "pizza", price: "$12"),
        FoodItem(name: "Dollar pizza", imageName: "pizza", price: "$18"),
        FoodItem(name: "Tikka pizza", imageName: "pizza", price: "$12")
    ]
    
    
    var cartItems: [CartDisplayItem] {
        cart.compactMap { (id, quantity) in
            if let item = (cakes + shakes + sweets).first(where: { $0.id == id }) {
                return CartDisplayItem(item: item, quantity: quantity)
            }
            return nil
        }
    }
    
    func addToCart(_ item: FoodItem) {
        cart[item.id, default: 0] += 1
    }
    
    func removeOne(_ item: FoodItem) {
        if let current = cart[item.id], current > 1 {
            cart[item.id] = current - 1
        } else {
            cart[item.id] = nil
        }
    }
    
    func placeOrder() {
        let newOrders = cartItems
        orders.append(contentsOf: newOrders)
        cart.removeAll()
    }
    
    func clearCart() {
        cart.removeAll()
    }
}

struct CartDisplayItem: Identifiable {
    let id = UUID()
    let item: FoodItem
    var quantity: Int
}


extension CartDisplayItem {
    func toCartItem() -> CartItem {
        return CartItem(
            image: Image(systemName: "cart"),
            name: item.name,
            description: "",
            price: Double(item.price.replacingOccurrences(of: "$", with: "")) ?? 0,
            quantity: quantity
        )
    }
}
