//
//  HomeView.swift
//  Food Order
//
//  Created by HarshaHrudhay on 15/09/25.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showMenu = false
    @State private var searchText = ""
    @State private var selectedFilter: String? = nil
    @State private var isLoggedOut = false
    
    @StateObject private var viewModel = HomeViewModel()
    
    var filteredItems: [FoodItem] {
        var allItems = viewModel.cakes + viewModel.shakes + viewModel.sweets + viewModel.pizza
        if let filter = selectedFilter {
            switch filter {
            case "Cakes": allItems = viewModel.cakes
            case "Shakes": allItems = viewModel.shakes
            case "Sweets": allItems = viewModel.sweets
            case "Pizzas": allItems = viewModel.pizza
            default: break
            }
        }
        if searchText.isEmpty {
            return []
        } else {
            return allItems.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.black
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {

                    ZStack {
                        Image("homebg")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                        
                        Text("Good food Good life")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .padding(.top, 120)
                    }
                    
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
                        
                        Menu {
                            Button("All") { selectedFilter = nil }
                            Button("Cakes") { selectedFilter = "Cakes" }
                            Button("Shakes") { selectedFilter = "Shakes" }
                            Button("Sweets") { selectedFilter = "Sweets" }
                            Button("Pizzas") { selectedFilter = "Pizzas"}
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                                .padding(.leading, 8)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    if !filteredItems.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(filteredItems) { item in
                                HStack {
                                    Image(item.imageName)
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(8)
                                    
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text(item.price)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    CartButtonView(item: item, viewModel: viewModel)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    CategoryView(title: "Cakes", items: viewModel.cakes, viewModel: viewModel)
                    CategoryView(title: "Shakes", items: viewModel.shakes, viewModel: viewModel)
                    CategoryView(title: "Sweets", items: viewModel.sweets, viewModel: viewModel)
                    CategoryView(title: "Pizzas", items: viewModel.pizza, viewModel: viewModel)
                    
                    
                    
                    Spacer(minLength: 100)
                }
            }
            
            NavigationLink(destination: CartView(viewModel: viewModel)) {
                Image(systemName: "cart.fill")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showMenu.toggle()
                } label: {
                    Image(systemName: "line.horizontal.3")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                }
                .confirmationDialog("Menu", isPresented: $showMenu, titleVisibility: .visible) {
                    NavigationLink("My Orders", destination: MyOrderView())
                    Button("Logout", role: .destructive) {
                        isLoggedOut = true
                    }
                    Button("Cancel", role: .cancel) {}
                }
            }
        }
        .background(
            NavigationLink(destination: PreLoginView(), isActive: $isLoggedOut) {
                EmptyView()
            }
        )
    }
}

struct CategoryView: View {
    
    let title: String
    let items: [FoodItem]
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
                    .opacity(0.5)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(items) { item in
                        VStack(spacing: 10) {
                            Image(item.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 100)
                                .clipped()
                                .cornerRadius(10)
                                .padding(.top)
                            
                            Text(item.name)
                                .font(.system(size: 15))
                                .foregroundColor(.white)
                            
                            Text(item.price)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            CartButtonView(item: item, viewModel: viewModel)
                        }
                        .frame(width: 140)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct CartButtonView: View {
    let item: FoodItem
    @ObservedObject var viewModel: HomeViewModel
    
    var quantity: Int {
        viewModel.cart[item.id] ?? 0
    }
    
    var body: some View {
        if quantity == 0 {
            Button(action: { viewModel.addToCart(item) }) {
                Text("Add to Cart")
                    .foregroundColor(.orange)
                    .font(.subheadline)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 12)
                    .overlay(
                        Capsule()
                            .stroke(Color.orange, lineWidth: 1.5)
                    )
            }
            .padding(.bottom)
        } else {
            HStack(spacing: 20) {
                Button(action: { viewModel.removeOne(item) }) {
                    Text("-")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.orange)
                }
                
                Text("\(quantity)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .frame(minWidth: 20)
                
                Button(action: { viewModel.addToCart(item) }) {
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
            .padding(.bottom)
        }
    }
}

#Preview {
    HomeView()
}
