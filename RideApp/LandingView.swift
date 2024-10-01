//
//  LandingView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/1/24.
//

import SwiftUI

struct LandingView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    
    @State private var isButtonPressed = false


    var body: some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
        
        NavigationView(content: {
            ZStack {
                Image("landing_page_background")
                    .resizable() // Makes the image resizable
                    .scaledToFill() // Scales the image to fill the screen
                    .ignoresSafeArea()
                VStack {
                    if orientation.isPortrait(device: .iPhone) {
                        
                        // Logo
                        ZStack() {
                            Text("RIDE")
                                .font(.system(size: isButtonPressed ? 32 : 96, weight: .heavy))
                                .foregroundColor(.white)
                                .offset(x: 0, y: isButtonPressed ? -110 : -9.50)
                                .animation(.easeInOut(duration: 0.4), value: isButtonPressed)
                            Text("Drive the future")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(hex: "64AFF4"))
                                .offset(x: 0, y: isButtonPressed ? 10 : 55)
                                .opacity(isButtonPressed ? 0 : 1)
                                .animation(.easeIn(duration: 0.2), value: isButtonPressed)
                        }
                        .frame(width: 216, height: 134)
                        .padding(.vertical, 120)
                        Spacer()
                        // Buttons
                        Button(action: {
                            withAnimation {
                                isButtonPressed.toggle()
                            }
                        }) {
                            Text("Login")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 349, height: 65)
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        }
                        .padding(.vertical, 5)

                        Button(action: {
                            withAnimation {
                                isButtonPressed.toggle()
                            }
                        }) {
                            Text("Sign Up")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 349, height: 65)
                                .background(
                                    Color(hex: "4FA0FF")
                                        .cornerRadius(5)
                                )
                        }
                        .padding(.vertical, 5)
                        
                        // Footer
                        Text("Copyright © 2024 Ride. All rights reserved.\n Created By: Jacob Rangel & Sage Turner")
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
            }
           
        })
        .navigationViewStyle(StackNavigationViewStyle())
        
        
        
        
    }
}

#Preview {
    LandingView()
}
