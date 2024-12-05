import SwiftUI
import FirebaseAuth

struct LoginFormView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var navigateToHome = false
    @State private var errorMessage = ""
    @State private var showAlert = false // Controls alert visibility
    
    var onLoginSuccess: (() -> Void)? // Optional callback for successful login

    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Login failed: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
                showAlert = true
            } else {
                print("User signed in successfully")
                onLoginSuccess?() // Notify parent of login success
                navigateToHome = true
            }
        }
    }

    var body: some View {
        VStack {
            // Email Field
            ZStack {
                Text("Email")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .offset(x: -155, y: -40)
                TextField("", text: $email)
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                    .frame(width: 349, height: 51)
                    .background(Color.black.opacity(0.30))
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 1))
            }
            .frame(width: 349, height: 72)
            .padding(.vertical, 5)

            // Password Field
            ZStack {
                Text("Password")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .offset(x: -140, y: -40)
                SecureField("", text: $password)
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                    .frame(width: 349, height: 51)
                    .background(Color.black.opacity(0.30))
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 1))
            }
            .frame(width: 349, height: 72)
            .padding(.vertical, 5)

            // Login Button
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
            .padding(.top)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Login Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK")) {
                    errorMessage = ""
                }
            )
        }
    }
}
