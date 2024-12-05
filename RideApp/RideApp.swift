//
//  RideAppApp.swift
//  RideApp
//
//  Created by Jacob Rangel on 9/28/24.
//

import SwiftUI
import Firebase

@main
struct RideApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}
