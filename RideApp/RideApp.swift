//
//  RideAppApp.swift
//  RideApp
//
//  Created by Jacob Rangel on 9/28/24.
//

import SwiftUI
import Firebase

//// AppDelegate to initialize Firebase
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
//}

@main
struct RideApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            LandingView()
        }
    }
}
