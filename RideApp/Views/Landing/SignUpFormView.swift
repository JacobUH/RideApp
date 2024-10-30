//
//  SignUpFormView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/22/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpFormView: View {
    
    @State private var firstname = ""
    @State private var lastname = ""
    @State private var email = ""
    @State private var password = ""
    @State private var navigateToHome = false
    
    private let db = Firestore.firestore() // Firestore instance
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let user = result?.user {
                // Save the first name and last name in Firestore
                db.collection("users").document(user.uid).setData([
                    "firstName": firstname,
                    "lastName": lastname,
                    "email": email
                ]) { error in
                    if let error = error {
                        print("Error saving user data: \(error.localizedDescription)")
                    } else {
                        print("User data saved successfully")
                        navigateToHome = true
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            // fname
            ZStack() {
                Text("First Name")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .offset(x: -137, y: -40)
                TextField("", text: $firstname)
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                    .frame(width: 349, height: 51)
                    .background(Color(.black).opacity(0.30))
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5).inset(by: 0.50).stroke(.white, lineWidth: 1))
            }
            .frame(width: 349, height: 72)
            .padding(.vertical, 5)
            
            // lname
            ZStack() {
                Text("Last Name")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .offset(x: -137, y: -40)
                TextField("", text: $lastname)
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                    .frame(width: 349, height: 51)
                    .background(Color(.black).opacity(0.30))
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5).inset(by: 0.50).stroke(.white, lineWidth: 1))
            }
            .frame(width: 349, height: 72)
            .padding(.vertical, 5)
            
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
                        register()
                    }) {
                        Text("Sign Up")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color(hex: "4FA0FF"))
                            .cornerRadius(5)
                            .padding(.horizontal)
                    }
                }
        }
    }
}
