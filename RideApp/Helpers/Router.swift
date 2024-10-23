//
//  Router.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/22/24.
//

import SwiftUI

class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    func dismiss() {
        path = NavigationPath()
    }
}
