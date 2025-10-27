//
//  ListRowCartView.swift
//  Food Order
//
//  Created by HarshaHrudhay on 15/09/25.
//

import SwiftUI

struct ListRowCartView: View {
    
    var cartItem: CartDisplayItem
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(cartItem.item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .clipped()
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(cartItem.item.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                Text(cartItem.item.price)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                HStack(spacing: 20) {
                    Button {
                        if viewModel.cart[cartItem.item.id] ?? 0 > 1 {
                            withAnimation { viewModel.cart[cartItem.item.id]! -= 1 }
                        }
                    } label: {
                        Text("-")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.orange)
                    }
                    
                    Text("\(viewModel.cart[cartItem.item.id] ?? 1)")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(minWidth: 20)
                    
                    
                    
                    Button {
                        withAnimation { viewModel.cart[cartItem.item.id]! += 1 }
                    } label: {
                        Text("+")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.orange)
                    }
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 18)
                .background(
                    Capsule()
                        .stroke(Color.orange, lineWidth: 1.5)
                )
            }
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

#Preview {
    ListRowCartView(
        cartItem: CartDisplayItem(
            item: FoodItem(name: "Chocolate Cake", imageName: "cake", price: "$8"),
            quantity: 2
        ),
        viewModel: HomeViewModel()
    )
}
