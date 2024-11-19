//
//  Card.swift
//  RideApp
//
//  Created by Jacob Rangel on 11/19/24.
//

import FirebaseFirestore

struct Card: Identifiable, Decodable, Hashable {
    @DocumentID var id: String? // This will automatically set the document ID
    var cardNumber: String
    var cardType: String
    var expDate: String
    var securityPin: String
}
