//
//  AdminInCompleteView.swift
//  Food Order
//
//  Created by HarshaHrudhay on 15/09/25.
//

import SwiftUI

struct AdminInCompleteView: View {
    
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "status == %@", "accepted")
    ) var acceptedOrders: FetchedResults<Order>
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

            ScrollView(showsIndicators: false) {
                    if acceptedOrders.isEmpty {
                        VStack {
                            Spacer()
                            Text("No Completed Orders Yet")
                                .foregroundColor(.gray)
                                .font(.title2)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ForEach(acceptedOrders) { order in
                            VStack(alignment: .leading, spacing: 12) {
                                Text("User: \(order.userEmail ?? "")")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                if let data = order.items,
                                   let decoded = try? JSONDecoder().decode([CartItemCodable].self, from: data) {
                                    ForEach(decoded) { item in
                                        HStack(alignment: .top, spacing: 12) {
                                            Image(systemName: "cart.fill")
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(.orange)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(item.name)
                                                    .foregroundColor(.white)
                                                    .font(.headline)
                                                
                                                Text("Qty: \(item.quantity)")
                                                    .foregroundColor(.gray)
                                                    .font(.subheadline)
                                                
                                                Text("$\(item.price, specifier: "%.2f")")
                                                    .foregroundColor(.green)
                                                    .font(.subheadline)
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(8)
                                        .background(Color.white.opacity(0.05))
                                        .cornerRadius(10)
                                    }
                                }
                                
                                HStack {
                                    Spacer()
                                    Text("Total: $\(order.total, specifier: "%.2f")")
                                        .foregroundColor(.green)
                                        .fontWeight(.semibold)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.top)
                .padding(.horizontal)
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Completed Orders")
        }
    }
}

#Preview {
    AdminInCompleteView()
}
