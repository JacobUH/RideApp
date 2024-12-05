//
//  AccountView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/1/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AccountView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    var onLogoutSuccess: (() -> Void)? // Callback for successful logout
    
    private let db = Firestore.firestore() // Firestore instance
    
    // State variables for user information
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var accountCreatedDate = ""
        
    private func fetchUserInfo() {
        guard let user = Auth.auth().currentUser else { return }
        
        // Fetching the account creation date from Firebase Auth
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        if let creationDate = user.metadata.creationDate {
            accountCreatedDate = dateFormatter.string(from: creationDate)
        } else {
            accountCreatedDate = "Unknown"
        }
        
        // Fetching first and last names from Firestore
        db.collection("users").document(user.uid).getDocument { document, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
            } else if let document = document, document.exists {
                let data = document.data()
                firstName = data?["firstName"] as? String ?? "Unknown"
                lastName = data?["lastName"] as? String ?? "User"
            }
        }
    }

    var body: some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
        
        NavigationView(content: {
            ZStack {
                Color(hex: "1C1C1E")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if orientation.isPortrait(device: .iPhone) {
                          
                        HStack (alignment: .center, spacing: 20){
                            VStack {
                                Text("\(firstName) \(lastName)")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundStyle(.white)
                                Text("Account Created: \(accountCreatedDate)")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(Color(hex: "4FA0FF"))
                            }
                            Image("profileImage")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(90)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 90)
                                      .inset(by: 0.50)
                                      .stroke(.white, lineWidth: 1)
                                  )
                        }
                        .padding(.top, 10).padding(.bottom, 30)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.clear)
                        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                        .shadow(
                          color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 10, y: 10
                        )
                        
                        // profile
                        NavigationLink(destination: ProfileView()
                            .navigationBarBackButtonHidden(true)
                        ) {
                            HStack {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 27))
                                    .foregroundStyle(Color(hex: "999999"))
                                    .padding(.leading, 20).padding(.trailing,10)
                                Text("Profile")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color(hex: "999999"))
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: 72)
                       }
                       
                        // activity
                        NavigationLink(destination: ActivityView()
                            .navigationBarBackButtonHidden(true)
                        ) {
                            HStack {
                                Image(systemName: "text.document.fill")
                                    .font(.system(size: 24))
                                    .foregroundStyle(Color(hex: "999999"))
                                    .padding(.leading, 20).padding(.trailing,10)
                                Text("Activity")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color(hex: "999999"))
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: 72)
                       }
                        
                        // messages
                        NavigationLink(destination: MessagesView()
                            .navigationBarBackButtonHidden(true)
                        ) {
                            HStack {
                                Image(systemName: "ellipsis.bubble.fill")
                                    .font(.system(size: 21.5))
                                    .foregroundStyle(Color(hex: "999999"))
                                    .padding(.leading, 20).padding(.trailing,10)
                                Text("Messages")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color(hex: "999999"))
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: 72)
                       }
                    
                        //wallet
                        NavigationLink(destination: WalletView()
                            .navigationBarBackButtonHidden(true)
                        ) {
                            HStack {
                                Image(systemName: "creditcard.fill")
                                    .font(.system(size: 20.5))
                                    .foregroundStyle(Color(hex: "999999"))
                                    .padding(.leading, 20).padding(.trailing,10)
                                Text("Wallet")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color(hex: "999999"))
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: 72)
                       }
            
                        // rewards
                        NavigationLink(destination: RewardsView()
                            .navigationBarBackButtonHidden(true)
                        ) {
                            HStack {
                                Image(systemName: "gift.fill")
                                    .font(.system(size: 24))
                                    .foregroundStyle(Color(hex: "999999"))
                                    .padding(.leading, 20).padding(.trailing,10)
                                Text("Rewards")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color(hex: "999999"))
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: 72)
                       }
                       
                        // settings
                        NavigationLink(destination: SettingsView(onLogoutSuccess: onLogoutSuccess)
                            .navigationBarBackButtonHidden(true)
                        ) {
                            HStack {
                                Image(systemName: "gear")
                                    .font(.system(size: 23))
                                    .foregroundStyle(Color(hex: "999999"))
                                    .padding(.leading, 20).padding(.trailing,10)
                                Text("Settings")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color(hex: "999999"))
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: 72)
                       }
                       
                        // help
                        NavigationLink(destination: HelpView()
                            .navigationBarBackButtonHidden(true)
                        ) {
                            HStack {
                                Image(systemName: "questionmark.diamond.fill")
                                    .font(.system(size: 23))
                                    .foregroundStyle(Color(hex: "999999"))
                                    .padding(.leading, 20).padding(.trailing,10)
                                Text("Help")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color(hex: "999999"))
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: 72)
                       }
                       
                        // legal
                        NavigationLink(destination: LegalView()
                            .navigationBarBackButtonHidden(true)
                        ) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundStyle(Color(hex: "999999"))
                                    .padding(.leading, 20).padding(.trailing,10)
                                Text("Legal")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color(hex: "999999"))
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: 72)
                       }
                        
                        Spacer()
                    }
                    else if orientation.isLandscape(device: .iPhone){}
                    else {}
                }
                
            }
           
        })
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Image(systemName: "person.crop.circle.fill")
            Text("Account")
        }
        .onAppear {
            fetchUserInfo()
        }
    }
}

#Preview {
    AccountView()
}
