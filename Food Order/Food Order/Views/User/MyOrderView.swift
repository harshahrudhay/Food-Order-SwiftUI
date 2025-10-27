//
//  MyOrderView.swift
//  Food Order
//
//  Created by HarshaHrudhay on 15/09/25.
//

import SwiftUI

struct MyOrderView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Order.id, ascending: false)]) private var orders: FetchedResults<Order>
    
    var body: some View {
        
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                

                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .padding(8)
                    }
                    
                    Spacer()
                    Text("Your Orders")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Color.clear.frame(width: 38, height: 38)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                
                if orders.isEmpty {

                    VStack(spacing: 12) {
                        Text("No Orders Yet")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.gray)
                        Text("Place your first order to see it here.")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 100)
                    Spacer()
                    
                } else {

                    VStack(spacing: 8) {
                        Text("Pending")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.orange)
                        
                        Text("Restaurant is accepting orders, please wait.\nYour token number is 16.")
                            .font(.system(size: 14))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    

                    ScrollView {
                        VStack(spacing: 14) {
                            ForEach(orders) { order in
                                if let data = order.items,
                                   let decoded = try? JSONDecoder().decode([CartItemCodable].self, from: data) {
                                    ForEach(decoded) { cartItem in
                                        HStack(spacing: 14) {
                                            Image(systemName: "cart")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 60, height: 60)
                                                .foregroundColor(.orange)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                HStack {
                                                    Text(cartItem.name)
                                                        .font(.system(size: 16, weight: .semibold))
                                                        .foregroundColor(.white)
                                                    Text("x\(cartItem.quantity)")
                                                        .font(.system(size: 14, weight: .medium))
                                                        .foregroundColor(.orange)
                                                }
                                                if !cartItem.description.isEmpty {
                                                    Text(cartItem.description)
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.white.opacity(0.7))
                                                }
                                            }
                                            Spacer()
                                        }
                                        .padding(12)
                                        .background(Color.white.opacity(0.08))
                                        .cornerRadius(12)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 80)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        MyOrderView()
    }
}
