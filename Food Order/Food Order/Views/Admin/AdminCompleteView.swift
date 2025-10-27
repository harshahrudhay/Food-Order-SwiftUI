//
//  AdminCompleteView.swift
//  Food Order
//
//  Created by HarshaHrudhay on 15/09/25.
//



import SwiftUI
import CoreData

struct AdminCompleteView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "status == %@", "pending")
    ) var pendingOrders: FetchedResults<Order>
    
    var body: some View {
        NavigationStack {
                VStack(spacing: 16) {
                    ScrollView(showsIndicators: false) {
                    
                    if pendingOrders.isEmpty {
                        VStack {
                            Spacer()
                            Text("No Pending Orders")
                                .foregroundColor(.gray)
                                .font(.title2)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity) 
                    } else {
                        ForEach(pendingOrders) { order in
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
                                
                                HStack {
                                    Spacer()
                                    Text("Total: $\(order.total, specifier: "%.2f")")
                                        .foregroundColor(.green)
                                        .fontWeight(.semibold)
                                }
                                
                                Button("Accept Order") {
                                    order.status = "accepted"
                                    try? viewContext.save()
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.green)
                                .padding(.top, 4)
                                
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.top, 16) 
                .padding(.horizontal)
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Pending Orders")
        }
    }
}

#Preview {
    AdminCompleteView()
}
