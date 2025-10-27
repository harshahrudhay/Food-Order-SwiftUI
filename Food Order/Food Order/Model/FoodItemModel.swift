//
//  FoodItemModel.swift
//  Food Order
//
//  Created by HarshaHrudhay on 15/09/25.
//

import Foundation

struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let price: String
}
