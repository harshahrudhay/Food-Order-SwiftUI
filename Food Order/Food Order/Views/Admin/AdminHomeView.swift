//
//  AdminHomeView.swift
//  Food Order
//
//  Created by HarshaHrudhay on 15/09/25.
//

import SwiftUI
import CoreData

struct AdminHomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isLoggedOut = false
    
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "status == %@", "pending")
    ) var pendingOrders: FetchedResults<Order>
    
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "status == %@", "accepted")
    ) var acceptedOrders: FetchedResults<Order>
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                
                HStack {
                    Text("Orders")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Button("Logout") {
                        isLoggedOut = true
                    }
                    .foregroundColor(.red)
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top)
                
                ScrollView(showsIndicators: false) {
                    
                    if !pendingOrders.isEmpty {
                        Text("Pending Orders")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        VStack(spacing: 16) {
                            ForEach(pendingOrders) { order in
                                orderCard(order: order, isPending: true)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    if !acceptedOrders.isEmpty {
                        Text("Completed Orders")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        VStack(spacing: 16) {
                            ForEach(acceptedOrders) { order in
                                orderCard(order: order, isPending: false)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .background(Color.black.ignoresSafeArea())
            
            .background(
                NavigationLink(destination: PreLoginView(), isActive: $isLoggedOut) {
                    EmptyView()
                }
            )
            .navigationBarBackButtonHidden(true)
        }
    }
    
    @ViewBuilder
    private func orderCard(order: Order, isPending: Bool) -> some View {
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
                            Text("Qty: \(item.quantity)")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                        Spacer()
                        Text("$\(item.price * Double(item.quantity), specifier: "%.2f")")
                            .foregroundColor(.green)
                    }
                    .padding(8)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(10)
                }
            }
            
            Divider()
                .background(Color.gray)
            
            HStack {
                Spacer()
                Text("Total: $\(order.total, specifier: "%.2f")")
                    .foregroundColor(.green)
                    .fontWeight(.semibold)
            }
            
            if isPending {
                Button("Accept Order") {
                    order.status = "accepted"
                    try? viewContext.save()
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        AdminHomeView()
    }
}
