//
//  MainView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/1/24.
//

import SwiftUI

struct LandingView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    
    let onLoginSuccess: () -> Void // Callback to notify MainView of successful login
    
    @State private var isLoginSelected = false
    @State private var isSignUpSelected = false
    @State private var showForm = false

    var body: some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)

        ZStack {
            Image("landing_page_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                if orientation.isPortrait(device: .iPhone) {
                    
                    // Logo
                    ZStack() {
                        Text("RIDE")
                            .font(.system(size: showForm ? 32 : 96, weight: .heavy))
                            .foregroundColor(.white)
                            .offset(y: showForm ? -110 : -9.50)
                            .animation(.easeInOut(duration: 0.4), value: showForm)
                            .onTapGesture {
                                if showForm {
                                    withAnimation {
                                        showForm = false
                                    }
                                }
                            }
                        Text("Drive the future")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "64AFF4"))
                            .offset(y: showForm ? 10 : 55)
                            .opacity(showForm ? 0 : 1)
                            .animation(.easeIn(duration: 0.2), value: showForm)
                    }
                    .frame(width: 216, height: 134)
                    .padding(.vertical, 120)
                    
                    Spacer()
                    
                    // Buttons
                    if !showForm {
                        VStack {
                            Button(action: {
                                withAnimation {
                                    isLoginSelected = true
                                    isSignUpSelected = false
                                    showForm.toggle()
                                }
                            }) {
                                Text("Login")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 349, height: 65)
                                    .background(RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.white, lineWidth: 2))
                            }
                            .padding(.vertical, 5)
                            
                            Button(action: {
                                withAnimation {
                                    isSignUpSelected = true
                                    isLoginSelected = false
                                    showForm.toggle()
                                }
                            }) {
                                Text("Sign Up")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 349, height: 65)
                                    .background(Color(hex: "4FA0FF"))
                                    .cornerRadius(5)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    
                    // Footer
                    Text("Copyright © 2024 RIDE. All rights reserved.\n Created By: Jacob Rangel & Sage Turner")
                        .font(.system(size: 10, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(width: 325, alignment: .center)
                        .padding()
                    
                }
                else if orientation.isLandscape(device: .iPhone){}
                else {}
            }
            .padding()
            
            // login/signup forms
            if showForm {
                VStack {
                    Spacer()
                    
                    Text(isLoginSelected ? "Welcome" : "Get Started")
                        .font(.system(size: 40, weight: .medium))
                        .foregroundColor(.white)
                    
                    VStack {
                        if isLoginSelected {
                            LoginFormView(onLoginSuccess: {
                                onLoginSuccess()
                            })
                        } else if isSignUpSelected {
                            SignUpFormView(onLoginSuccess: {
                                onLoginSuccess()
                            })
                        }
                    }
                    .padding()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.5), value: showForm)
                    
                    HStack {
                        Image(systemName: "chevron.left") // Back arrow icon
                            .font(.system(size: 13, weight: .heavy))
                            .foregroundColor(.white)
                        
                        Text("Go Back")
                            .font(.system(size: 15, weight: .heavy))
                            .foregroundColor(.white)
                    }
                    .onTapGesture {
                        if showForm {
                            withAnimation {
                                showForm = false
                            }
                        }
                    }
                    
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
            }
        }

    }
}

#Preview {
    MainView()
}
