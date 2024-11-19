//
//  LoginFormView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/22/24.
//

import SwiftUI
import FirebaseAuth

struct LoginFormView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var navigateToHome = false
    @State private var errorMessage = ""
        
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
                errorMessage = "\(error.localizedDescription)"
            } else {
                print("User signed in successfully")
                navigateToHome = true
            }
        }
    }
    
    var body: some View {
        VStack {
        
            // email
            ZStack() {
                Text("Email")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .offset(x: -155, y: -40)
                TextField("", text: $email)
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                    .frame(width: 349, height: 51)
                    .background(Color(.black).opacity(0.30))
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5).inset(by: 0.50).stroke(.white, lineWidth: 1))
            }
            .frame(width: 349, height: 72)
            .padding(.vertical, 5)
            
            // password
            ZStack() {
                Text("Password")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .offset(x: -140, y: -40)
                SecureField("", text: $password)
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                    .frame(width: 349, height: 51)
                    .background(Color(.black).opacity(0.30))
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5).inset(by: 0.50).stroke(.white, lineWidth: 1))
            }
            .frame(width: 349, height: 72)
            .padding(.vertical, 5)

            NavigationLink(destination: ContentView()
                .navigationBarBackButtonHidden(true),
                isActive: $navigateToHome) {
                    Button(action: {
                        login()
                    }) {
                        Text("Login")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color(hex: "4FA0FF"))
                            .cornerRadius(5)
                            .padding(.horizontal)
                    }
                }
        }
        .alert(isPresented: .constant(!errorMessage.isEmpty), content: {
            Alert(
                title: Text("Login Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"), action: {
                    errorMessage = ""
                })
            )
        })
    }
}
