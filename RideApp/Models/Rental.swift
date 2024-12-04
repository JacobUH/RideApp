//
//  Rental.swift
//  RideApp
//
//  Created by Jacob Rangel on 11/19/24.
//

import FirebaseFirestore

struct Rental: Identifiable, Decodable, Hashable {
    @DocumentID var id: String? // This will automatically set the document ID
    var carModel: CarDetails  // Change from String to CarDetails
    var pickupDate: Date
    var dropoffDate: Date
    var totalCost: Double
    var selectedCard: Card
}
