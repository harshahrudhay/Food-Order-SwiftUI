//
//  PreLoginView.swift
//  Food Order
//
//  Created by HarshaHrudhay on 15/09/25.
//

import SwiftUI

struct PreLoginView: View {
    
    var body: some View {
        
        NavigationStack{
            
            ZStack {
                
                Color.black
                    .ignoresSafeArea()
                
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
                        
                        NavigationLink {
                            
                            LoginView()
                            
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
                        
                        
                        NavigationLink {
                            
                            RegisterView()
                            
                        } label: {
                            Text("Sign Up")
                                .font(.headline)
                                .foregroundColor(.orange)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .white.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 50)
                    
                     Spacer()
                    
                }
                
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    NavigationStack {
        PreLoginView()
    }
}
