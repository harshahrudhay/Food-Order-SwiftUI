//
//  Food_OrderApp.swift
//  Food Order
//
//  Created by HarshaHrudhay on 27/10/25.
//

import SwiftUI
import CoreData

@main
struct Food_OrderApp: App {
    
    @StateObject var cartManager = CartManager()
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        
        WindowGroup {
            
            PreLoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(cartManager)
        }
    }
}
