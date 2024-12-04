//
//  Ride.swift
//  RideApp
//
//  Created by Sage Turner on 12/4/24.
//

import FirebaseFirestore

struct Ride: Identifiable, Decodable, Hashable {
    @DocumentID var id: String? // This will automatically set the document ID
    var carModel: CarDetails  // Change from String to CarDetails
    var arrivalTime: Date
    var totalCost: Double
    var originAddress: String
    var destinationAddress: String
    var selectedCard: Card
}

//carModel: CarDetails, image: String, arrivalTime: Date, totalCost: Double, selectedCard: Card
