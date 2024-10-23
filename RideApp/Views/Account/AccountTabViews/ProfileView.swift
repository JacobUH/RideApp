//
//  ProfileView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/3/24.
//

import SwiftUI

struct ProfileRow: View {
    var label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
                .background(Color.gray)

            HStack {
                Text(label)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.leading, 15)

                Spacer()

                TextField("", text: $text)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.gray)
                    .padding(.trailing, 15)
            }
        }
    }
}

struct ProfileView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode
    
    @State private var firstName = "Jacob"
    @State private var lastName = "Rangel"
    @State private var email = "jacobrangel0628@gmail.com"
    @State private var phone = "(832) 123 4567"
    @State private var gender = "Male"

    var body: some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
        
        NavigationView(content: {
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
                            Text("Edit Profile")
                                .padding(.all, 10)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(hex: "#4FA0FF"))
                            
                            VStack(spacing: 16) {
                                ProfileRow(label: "First Name", text: $firstName)
                                ProfileRow(label: "Last Name", text: $lastName)
                                ProfileRow(label: "Email", text: $email)
                                ProfileRow(label: "Phone", text: $phone)
                                ProfileRow(label: "Gender", text: $gender)
                                
                                Divider()
                                    .background(Color.gray)
                            }
                        }
                        .padding(.top, 30)
                        
                        
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
        
        
    }
}

#Preview {
    ProfileView()
}
