//
//  AdminTabView.swift
//  Food Order
//
//  Created by HarshaHrudhay on 15/09/25.
//

import SwiftUI

struct AdminTabView: View {
    var body: some View {
        TabView {
            AdminHomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("All")
                }
            
            AdminCompleteView()
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Pending")
                }
            
            AdminInCompleteView()
                .tabItem {
                    Image(systemName: "checkmark.circle")
                    Text("Completed")
                }
        }
        .tint(.orange)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack {
        AdminTabView()
    }
}
