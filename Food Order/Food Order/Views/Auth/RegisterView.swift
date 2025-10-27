//
//  RegisterView.swift
//  Food Order
//
//  Created by HarshaHrudhay on 15/09/25.
//

import SwiftUI
import CoreData

struct RegisterView: View {

    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: UserVM = UserVM()     // auth - usr update -rm auth

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 24) {
                

                Image(systemName: "fork.knife.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.orange)
                    .padding(.top, 50)
                

                Text("Food Bank")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Special And Delicious Food")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                

                Text("Create Account")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top)
                

                VStack(spacing: 16) {
                    TextField("Full Name", text: $viewModel.name)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .autocapitalization(.words)
                    
                    TextField("Email Address", text: $viewModel.email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 32)
                

                Button(action: registerUser) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(12)
                        .shadow(color: .orange.opacity(0.5), radius: 5, x: 0, y: 3)
                }
                .padding(.horizontal, 32)
                

                NavigationLink(destination: HomeView(), isActive: $viewModel.isLoggedIn) {
                    EmptyView()
                }.hidden()
                

                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.white)
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Log In")
                            .foregroundColor(.teal)
                    }
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarBackButtonHidden()
    }


    func registerUser() {
        if viewModel.name.isEmpty || viewModel.email.isEmpty || viewModel.password.isEmpty
            || viewModel.name.count <= 3
            || !viewModel.email.contains("@")
//            || !viewModel.email.contains(".")
            || viewModel.password.count <= 4 {
            
            viewModel.alertMessage = "Please fill the details correctly: Name > 3 letters, valid email ('@'), password > 4 characters."
            viewModel.showAlert = true
            return
        }

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", viewModel.email)

        do {
            let existingUsers = try viewContext.fetch(fetchRequest)
            if !existingUsers.isEmpty {
                viewModel.alertMessage = "Email already registered"
                viewModel.showAlert = true
                return
            }
            
            let newUser = User(context: viewContext)
            newUser.name = viewModel.name
            newUser.email = viewModel.email
            newUser.password = viewModel.password
            
            try viewContext.save()
            
            viewModel.name = ""
            viewModel.email = ""
            viewModel.password = ""
            
            viewModel.isLoggedIn = true
        } catch {
            viewModel.alertMessage = "Failed to save user: \(error.localizedDescription)"
            viewModel.showAlert = true
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}
