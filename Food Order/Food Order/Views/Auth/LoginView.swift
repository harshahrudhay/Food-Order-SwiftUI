//
//  LoginView.swift
//  Food Order
//
//  Created by HarshaHrudhay on 15/09/25.
//

import SwiftUI
import CoreData

struct LoginView: View {
    
    @StateObject var viewModel: UserVM = UserVM()     // auth - uservm - rm
    
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var users: FetchedResults<User>
    
    let adminEmail: String = "harsha"
    let adminPassword: String = "harsha"
    @State private var isNavigatingToAdminDashboard = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    
                    
                    Image(systemName: "fork.knife.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.orange)
                        .padding(.top, 50)
                    

                    Text("Food Bunk")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Food • Dine • Friends")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    

                    VStack(spacing: 16) {
                        TextField("E-Mail", text: $viewModel.email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $viewModel.password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                        

                        NavigationLink(destination: AdminTabView(), isActive: $isNavigatingToAdminDashboard) { EmptyView() }
                        NavigationLink(destination: HomeView(), isActive: $viewModel.isLoggedIn) { EmptyView() }
                        

                        Button {
                            if !viewModel.email.isEmpty && !viewModel.password.isEmpty {
                                if viewModel.email == adminEmail && viewModel.password == adminPassword {
                                    isNavigatingToAdminDashboard = true
                                } else if let user = users.first(where: { $0.email == viewModel.email && $0.password == viewModel.password }) {
                                    viewModel.name = user.name ?? ""
                                    viewModel.isLoggedIn = true
                                } else {
                                    viewModel.alertMessage = "Invalid credentials"
                                    viewModel.showAlert = true
                                }
                            } else {
                                viewModel.alertMessage = "Please fill in all fields"
                                viewModel.showAlert = true
                            }
                        } label: {
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(12)
                                .shadow(color: .orange.opacity(0.5), radius: 5, x: 0, y: 3)
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                    
                    HStack {
                        Text("Don't have an account?")
                            .foregroundStyle(.white)
                        NavigationLink(destination: RegisterView()) {
                            Text("Sign Up")
                                .foregroundStyle(.teal)
                        }
                    }
                    
                    Spacer()
                    
                }
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    LoginView()
}
