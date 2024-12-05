//
//  ContentView.swift
//  RideApp
//
//  Created by Jacob Rangel on 9/28/24.
//

import SwiftUI

struct ContentView: View {
    var onLogoutSuccess: (() -> Void)? // Optional callback for successful login
    @Binding var selectedTab: Int 

    init(onLogoutSuccess: (() -> Void)? = nil, selectedTab: Binding<Int>) {
        self.onLogoutSuccess = onLogoutSuccess
        self._selectedTab = selectedTab

        // Set the UITabBar background color
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Color(hex: "101011"))
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                RidesView()
                    .environment(\.colorScheme, .dark)
                    .tag(1)
                RentalsView()
                    .tag(2)
                AccountView(onLogoutSuccess: onLogoutSuccess)
                    .tag(3)
            }
        }
    }
}

#Preview {
    ContentView(onLogoutSuccess: nil, selectedTab: .constant(0))
}
