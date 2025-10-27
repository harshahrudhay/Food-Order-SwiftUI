//
//  CartView.swift
//  Food Order
//
//  Created by HarshaHrudhay on 15/09/25.
//

import SwiftUI
import CoreData

struct CartView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @State private var navigateToOrder = false
    @State private var searchText = ""
    
    var body: some View {
        
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .padding(8)
                        }
                        Spacer()
                        Text("My Cart")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        Color.clear.frame(width: 38, height: 38)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search", text: $searchText)
                                .foregroundColor(.black)
                        }
                        .padding(10)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(25)
                        
                        Button {} label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                                .padding(.leading, 8)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                }
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.cartItems) { cartItem in
                            ListRowCartView(cartItem: cartItem, viewModel: viewModel)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
                
                HStack(spacing: 12) {
                    Button { dismiss() } label: {
                        Text("Go to List")
                            .font(.headline)
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    
                    Button {
                        saveOrder()
                        navigateToOrder = true
                    } label: {
                        Text("Place Order")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.cartItems.isEmpty ? Color.gray : Color.orange)
                            .cornerRadius(12)
                    }
                    .disabled(viewModel.cartItems.isEmpty)
                    
                    NavigationLink(
                        destination: MyOrderView()
                            .environment(\.managedObjectContext, viewContext),
                        isActive: $navigateToOrder
                    ) { EmptyView() }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                .padding(.top)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func saveOrder() {
        guard !viewModel.cartItems.isEmpty else { return }
        
        let newOrder = Order(context: viewContext)
        newOrder.id = UUID()
        newOrder.userEmail = "user@email.com"
        newOrder.total = viewModel.cartItems.reduce(0) {
            $0 + (Double($1.item.price.replacingOccurrences(of: "$", with: "")) ?? 0) * Double($1.quantity)
        }
        newOrder.status = "pending"
        
        if let encoded = try? JSONEncoder().encode(viewModel.cartItems.map { CartItemCodable(from: $0.toCartItem()) }) {
            newOrder.items = encoded
        }
        
        try? viewContext.save()
        viewModel.clearCart()
    }
}

#Preview {
    NavigationStack {
        CartView(viewModel: HomeViewModel())
    }
}
