//
//  CarList.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/22/24.
//

import Foundation
import FirebaseFirestore

struct CarList: Codable {
    let cars: [CarDetails]
}

struct CarDetails: Codable, Hashable {
    let carName: String
    let carType: String
    let interior: String
    let exterior: String
    let engine: String
    let horsepower: String
    let mileage: String
    let transmission: String
    let driveType: String
    let features: Features
    let images: [String]
    let dailyCost: String
    
    struct Features: Codable, Hashable {
        let entertainment: String
        let convenience: String
        let packages: String
    }
    
    static func == (lhs: CarDetails, rhs: CarDetails) -> Bool {
        return lhs.carName == rhs.carName && lhs.interior == rhs.interior && lhs.exterior == rhs.exterior && lhs.engine == rhs.engine
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(carName)
        hasher.combine(interior)
        hasher.combine(exterior)
        hasher.combine(engine)
    }
}
