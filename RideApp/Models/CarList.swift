//
//  CarList.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/22/24.
//

import Foundation

struct CarList: Codable {
    let cars: [CarDetails]
}

struct CarDetails: Codable {
    let carName: String
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
    
    struct Features: Codable {
        let entertainment: String
        let convenience: String
        let packages: String
    }
}
