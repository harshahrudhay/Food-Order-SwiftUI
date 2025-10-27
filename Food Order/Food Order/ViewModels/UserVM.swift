//
//  UserVM.swift
//  Food Order
//
//  Created by HarshaHrudhay on 15/09/25.
//

import Foundation
import Combine

class UserVM: ObservableObject {
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var message: String = ""
    @Published var alertMessage: String = ""
    
    @Published var showMessage : Bool = false
    @Published var Navigate : Bool = false
    @Published var showAlert: Bool = false
    @Published var isLoggedIn: Bool = false
    @Published var isLoggedOut: Bool = false
    
}
