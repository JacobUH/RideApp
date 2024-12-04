//
//  CardDetailsSheet.swift
//  RideApp
//
//  Created by Jacob Rangel on 11/19/24.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct CardDetailsSheet: View {
    @Environment(\.dismiss) var dismiss

    let card: Card
    @State private var cardNumber: String
    @State private var cardType: String
    @State private var expDate: String
    @State private var securityPin: String
    
    private let db = Firestore.firestore() // Firestore instance
    @State private var showAlert = false
    @State private var alertMessage = ""

    init(card: Card) {
        self.card = card
        _cardNumber = State(initialValue: card.cardNumber)
        _cardType = State(initialValue: card.cardType)
        _expDate = State(initialValue: card.expDate)
        _securityPin = State(initialValue: card.securityPin)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Card Type")) {
                    Picker("Select Card Type", selection: $cardType) {
                        Text("Visa").tag("Visa")
                        Text("Mastercard").tag("Mastercard")
                        Text("Discover").tag("Discover")
                        Text("American Express").tag("American Express")
                        Text("Apple Pay").tag("Apple Pay")
                    }
                }
                Section(header: Text("Card Number")) {
                    TextField("Enter Credit Card Number", text: $cardNumber)
                }
                
                Section(header: Text("Expiration Date")) {
                    TextField("Enter Expiration Date", text: $expDate)
                }
                
                Section(header: Text("Security Pin")) {
                    TextField("Enter Security Pin", text: $securityPin)
                }
                
                Button(role: .destructive) {
                    if let cardId = card.id {
                        deleteCard(cardId: cardId)
                        dismiss()
                    } else {
                        print("Error: Missing card ID. Cannot delete card.")
                    }
                } label: {
                   Text("Delete Card")
                       .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Card Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationTitle(card.cardType)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                   Button("Save") {
                       if let cardId = card.id {
                           saveCardChanges(
                               cardId: cardId,
                               cardNumber: cardNumber,
                               cardType: cardType,
                               expDate: expDate,
                               securityPin: securityPin
                           )
                       } else {
                           addNewCard(
                               cardNumber: cardNumber,
                               cardType: cardType,
                               expDate: expDate,
                               securityPin: securityPin
                           )
                       }
                       if showAlert != true {
                           dismiss()
                       }
                   }
               }
            }
        }
    }

    private func saveCardChanges(cardId: String, cardNumber: String, cardType: String, expDate: String, securityPin: String) {
        guard let currentUser = Auth.auth().currentUser else {
            print("No authenticated user found.")
            return
        }
        
        // Input validation
        if cardType.isEmpty {
            alertMessage = "Card Type cannot be empty."
            showAlert = true
            return
        }

        if cardNumber.isEmpty {
            alertMessage = "Card Number cannot be empty."
            showAlert = true
            return
        }
        
        if expDate.isEmpty {
            alertMessage = "Expiration Date cannot be empty."
            showAlert = true
            return
        }
        
        if securityPin.isEmpty {
            alertMessage = "Security Pin cannot be empty."
            showAlert = true
            return
        }

        // Data to update
        let updatedData: [String: Any] = [
            "cardNumber": cardNumber,
            "cardType": cardType,
            "expDate": expDate,
            "securityPin": securityPin,
            "userId": currentUser.uid // Ensure userId stays consistent
        ]

        db.collection("user_wallets").document(cardId).updateData(updatedData) { error in
            if let error = error {
                print("Error updating card: \(error.localizedDescription)")
            } else {
                print("Card updated successfully!")
            }
        }
    }
    
    private func addNewCard(cardNumber: String, cardType: String, expDate: String, securityPin: String) {
        guard let currentUser = Auth.auth().currentUser else {
            print("No authenticated user found.")
            return
        }
        
        // Input validation
        if cardType.isEmpty {
            alertMessage = "Card Type cannot be empty."
            showAlert = true
            return
        }

        if cardNumber.isEmpty {
            alertMessage = "Card Number cannot be empty."
            showAlert = true
            return
        }
        
        if expDate.isEmpty {
            alertMessage = "Expiration Date cannot be empty."
            showAlert = true
            return
        }
        
        if securityPin.isEmpty {
            alertMessage = "Security Pin cannot be empty."
            showAlert = true
            return
        }

        let newCardData: [String: Any] = [
            "cardNumber": cardNumber,
            "cardType": cardType,
            "expDate": expDate,
            "securityPin": securityPin,
            "userId": currentUser.uid
        ]

        db.collection("user_wallets").addDocument(data: newCardData) { error in
            if let error = error {
                print("Error adding new card: \(error.localizedDescription)")
            } else {
                print("New card added successfully!")
            }
        }
    }
    
    private func deleteCard(cardId: String) {
        db.collection("user_wallets").document(cardId).delete { error in
            if let error = error {
                print("Error deleting card: \(error.localizedDescription)")
            } else {
                print("Card deleted successfully!")
            }
        }
    }
}
