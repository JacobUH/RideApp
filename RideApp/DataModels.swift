//
//  DataModels.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/8/24.
//

import Foundation

struct Rentals: Codable {
    let Rentals: [CarDetails]
}

struct CarDetails: Codable {
    let carName: String
    let interior, exterior, engine, horsepower, mileage, transmission, driveType: String
    let entertainment, convenience, packages: String
    let images: [String]
    let dailyCost: String

//    enum CodingKeys: String, CodingKey {
//        case logo, title, amount, type, description
//        case merchantType = "merchant_type"
//        case method, address, phone
//    }
}
