//
//  SplashScreenView.swift
//  RideApp
//
//  Created by Jacob Rangel on 12/5/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive: Bool = false
    @State private var logoScale: CGFloat = 1.0
    @State private var fadeOpacity: Double = 1.0
    @State private var landingViewOpacity: Double = 0.0
    @State private var showMapUpdateText: Bool = false

    var body: some View {
        ZStack {
            MainView()
                .opacity(landingViewOpacity)
                .edgesIgnoringSafeArea(.all)
            
            // Splash screen content
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "4FA0FF"), Color(hex: "1B346C")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Text("RIDE")
                        .font(.system(size: 96, weight: .heavy))
                        .foregroundColor(.white)
                        .scaleEffect(logoScale)
                        .opacity(fadeOpacity)

                    if showMapUpdateText {
                        Text("Drive The Future")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .opacity(fadeOpacity)
                    }
                    
                    Spacer()

                    Text("Copyright © 2024 RIDE. All rights reserved.\n Created By: Jacob Rangel & Sage Turner")
                        .font(.system(size: 10, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(width: 325, alignment: .center)
                        .padding(.bottom, 30)
                }
            }
            .opacity(1.0 - landingViewOpacity) // Fade out Splash Screen as LandingView fades in
        }
        .onAppear {
            // Show subtitle text
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    self.showMapUpdateText = true
                }
            }

            // Zoom and fade logo, fade in LandingView
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 1.5)) {
                    self.logoScale = 3.0
                    self.fadeOpacity = 0.0
                    self.landingViewOpacity = 1.0
                }
            }

            // Complete transition after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
