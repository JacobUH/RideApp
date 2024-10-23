//
//  ContentView.swift
//  RideApp
//
//  Created by Jacob Rangel on 9/28/24.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        // Set the UITabBar background color
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Color(hex: "101011"))
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    var body: some View {
        VStack {
            TabView{
                HomeView()
                RidesView()
                RentalsView()
                AccountView()
            }
        }
    }
}

#Preview {
    ContentView()
}
