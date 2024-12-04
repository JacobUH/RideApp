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
    @State private var errorMessage = ""
    
    private var passwordStrength: (color: Color, text: String) {
        let lengthScore = password.count >= 8 ? 1 : 0
        let uppercaseScore = password.range(of: "[A-Z]", options: .regularExpression) != nil ? 1 : 0
        let numberScore = password.range(of: "[0-9]", options: .regularExpression) != nil ? 1 : 0
        let specialCharScore = password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil ? 1 : 0
        
        let score = lengthScore + uppercaseScore + numberScore + specialCharScore
        
        switch score {
        case 0:
            return (Color.red, "Very Weak")
        case 1:
            return (Color.orange, "Weak")
        case 2:
            return (Color.yellow, "Moderate")
        case 3:
            return (Color.green, "Strong")
        case 4:
            return (Color.blue, "Very Strong")
        default:
            return (Color.gray, "Unknown")
        }
    }
        
    private let db = Firestore.firestore() // Firestore instance
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else if let user = result?.user {
                // Save the first name and last name in Firestore
                db.collection("users").document(user.uid).setData([
                    "firstName": firstname,
                    "lastName": lastname,
                    "email": email,
                    "phone" : "~",
                    "gender" : "",
                ]) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        errorMessage = "Error saving user data: \(error.localizedDescription)"
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
            
            HStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(passwordStrength.color)
                    .frame(height: 8)
                    .padding(.horizontal, 10)
                Text(passwordStrength.text)
                    .font(.caption)
                    .foregroundColor(passwordStrength.color)
            }
            .frame(width: 349, height: 20)
            .padding(.top, -10)
            
            NavigationLink(destination: ContentView()
                .navigationBarBackButtonHidden(true),
                isActive: $navigateToHome) {
                    Button(action: {
                        if firstname.isEmpty || lastname.isEmpty {
                            errorMessage = "Please enter both first and last names."
                        } else {
                            register()
                        }
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
                .padding(.top, 20)
        }
        .alert(isPresented: .constant(!errorMessage.isEmpty), content: {
            Alert(
                title: Text("Registration Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"), action: {
                    errorMessage = ""
                })
            )
        })
    }
}
