import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode
    
    private let db = Firestore.firestore() // Firestore instance
    
    // User information
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var gender = ""
    
    @State private var isSaving = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    func fetchUserInfo() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No authenticated user found.")
            return
        }

        // Fetch user info from "users" collection
        db.collection("users").document(currentUser.uid).getDocument { document, error in
            if let error = error {
                print("Error fetching user info: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists {
                let data = document.data()
                self.firstName = data?["firstName"] as? String ?? ""
                self.lastName = data?["lastName"] as? String ?? ""
                self.email = data?["email"] as? String ?? ""
                self.phone = data?["phone"] as? String ?? ""
                self.gender = data?["gender"] as? String ?? ""
            } else {
                print("User document does not exist.")
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func saveUserInfo() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No authenticated user found.")
            return
        }
        
        // Input validation
        if firstName.isEmpty {
            alertMessage = "First name cannot be empty."
            showAlert = true
            return
        }
        
        if lastName.isEmpty {
            alertMessage = "Last name cannot be empty."
            showAlert = true
            return
        }
        
        if email.isEmpty {
            alertMessage = "Email cannot be empty."
            showAlert = true
            return
        }
        
        if !isValidEmail(email) {
            alertMessage = "Please enter a valid email address."
            showAlert = true
            return
        }

        // Update Firestore with new user info
        isSaving = true
        db.collection("users").document(currentUser.uid).setData([
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "phone": phone,
            "gender": gender
        ], merge: true) { error in
            isSaving = false
            if let error = error {
                self.alertMessage = "Error saving user info: \(error.localizedDescription)"
            } else {
                self.alertMessage = "Your changes have been saved successfully!"
            }
            self.showAlert = true
        }
    }

    var body: some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
        
        NavigationView {
            ZStack {
                Color(hex: "1C1C1E")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if orientation.isPortrait(device: .iPhone) {
                        ZStack {
                            HStack {
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Image(systemName: "chevron.backward")
                                        .foregroundStyle(Color(hex: "999999"))
                                        .padding(.leading)
                                }
                                Spacer()
                            }
                            
                            Text("Profile")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.clear)
                        .background(Color(hex: "1C1C1E"))
                        .shadow(
                          color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 10, y: 10
                        )
                        
                        VStack {
                            Image("profileImage")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(90)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 90)
                                      .inset(by: 0.50)
                                      .stroke(.white, lineWidth: 1)
                                  )
                            Text("Change Profile Picture")
                                .padding(.all, 10)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(hex: "#4FA0FF"))
                            
                            VStack(spacing: 16) {
                                ProfileRow(label: "First Name", text: $firstName)
                                ProfileRow(label: "Last Name", text: $lastName)
                                ProfileRow(label: "Email", text: $email)
                                PhoneRow(text: $phone)
                                GenderRow(text: $gender)
                                
                                Divider()
                                    .background(Color.gray)
                            }
                            .padding()

                            Button(action: saveUserInfo) {
                                if isSaving {
                                    ProgressView()
                                        .padding()
                                } else {
                                    Text("Save Changes")
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color(hex: "#4FA0FF"))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            .padding(.top, 20)
                            .padding([.leading, .trailing])
                        }
                        .padding(.top, 30)
                        
                        Spacer()
                    }
                    else if orientation.isLandscape(device: .iPhone) {}
                    else {}
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Profile Update"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onAppear {
            fetchUserInfo()
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Image(systemName: "person.crop.circle.fill")
            Text("Account")
        }
    }
}

#Preview {
    ProfileView()
}
