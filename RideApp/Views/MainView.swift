//
//  MainView.swift
//  RideApp
//
//  Created by Jacob Rangel on 12/3/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct MainView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    
    var onLoginSuccess: (() -> Void)? // Callback for successful login
    var onLogoutSuccess: (() -> Void)? // Callback for successful logout

    @State private var isLoggedIn = false
    @State private var showLandingView = true // Controls the visibility of LandingView
    @State private var selectedTab = 0

    private func checkLoginStatus() {
        if let currentUser = Auth.auth().currentUser {
            // User is logged in
            isLoggedIn = true
            showLandingView = false
            print("User is logged in: \(currentUser.email ?? "No email available")")
        } else {
            // No user is logged in
            isLoggedIn = false
            showLandingView = true
            print("No user is logged in")
        }
    }


    var body: some View {
        ZStack {
            // Main ContentView
            ContentView(onLogoutSuccess: {
                withAnimation {
                    self.showLandingView = true
                    self.isLoggedIn = false
                    self.selectedTab = 0
                }
            }, selectedTab: $selectedTab)
            .disabled(showLandingView) // makes nothing tappable
            .blur(radius: showLandingView ? 10 : 0) // hides the contentView
            
            // Overlay LandingView
            if showLandingView {
                LandingView(onLoginSuccess: {
                    withAnimation {
                        self.showLandingView = false
                        self.isLoggedIn = true
                        self.selectedTab = 0
                    }
                })
                .transition(.opacity) // Fade in/out transition
            }
        }
        .onAppear {
            checkLoginStatus()
        }
    }
}
