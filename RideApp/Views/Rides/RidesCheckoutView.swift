//
//  RidesCheckoutView.swift
//  RideApp
//
//  Created by Sage Turner on 10/24/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RidesCheckoutView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode
    
//    Connect to the database
    private let db = Firestore.firestore()

    @State private var showAlert = false
    @State private var errorMessage = ""
    
    @State private var userCards: [Card] = []
    @State private var selectedCard: Card?
    @State private var showCardPicker = false
    
    @State private var showAddPayment = false
    @State private var newCard: Card?
    
    var carModel: CarDetails
    var origin: String
    var destination: String
    var subtotal: Double
    var distance: Double
    var arrivalTime: Date
    
    @Binding var navigationPath: NavigationPath
    @State private var navigateToConfirmation = false
    
    func saveRideDetails(carModel: CarDetails, image: String, arrivalTime: Date, totalCost: Double, selectedCard: Card) {
        guard let currentUser = Auth.auth().currentUser else {
            errorMessage = "No authenticated user found. Please log in first."
            return
        }
        
        let carModelData: [String: Any] = [
            "carName": carModel.carName,
            "carType": carModel.carType,
            "interior": carModel.interior,
            "exterior": carModel.exterior,
            "engine": carModel.engine,
            "horsepower": carModel.horsepower,
            "mileage": carModel.mileage,
            "transmission": carModel.transmission,
            "driveType": carModel.driveType,
            "features": [
                "entertainment": carModel.features.entertainment,
                "convenience": carModel.features.convenience,
                "packages": carModel.features.packages
            ],
            "images": carModel.images,
            "dailyCost": carModel.dailyCost
        ]
        
        let cardData: [String: Any] = [
            "cardType": selectedCard.cardType,
            "cardNumber": "****\(selectedCard.cardNumber.suffix(4))", // Mask the card number
            "expDate": selectedCard.expDate,
            "securityPin": "****" // Mask the security PIN for privacy
        ]
        
        let rideData: [String: Any] = [
            "carModel": carModelData,
            "image": image,
            "arrivalTime": Timestamp(date: arrivalTime),
            "totalCost": totalCost,
            "originAddress": origin,
            "destinationAddress": destination,
            "userId": currentUser.uid,
            "userEmail": currentUser.email ?? "Unknown",
            "selectedCard": cardData
        ]
        
        db.collection("user_rides").addDocument(data: rideData) { error in
            if let error = error {
                print("Error saving ride data: \(error.localizedDescription)")
                errorMessage = "Error saving ride data: \(error.localizedDescription)"
            } else {
                print("Ride data saved successfully")
            }
        }
    }
    
//    Grabs User Cards from the database
    func fetchUserCards() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No authenticated user found.")
            return
        }

        db.collection("user_wallets")
            .whereField("userId", isEqualTo: currentUser.uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching cards: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No cards found for the user.")
                    return
                }

                self.userCards = documents.compactMap { doc in
                    do {
                        return try doc.data(as: Card.self)
                    } catch {
                        print("Error decoding card data: \(error)")
                        return nil
                    }
                }
            }
    }
    
    var dailyCost: Double {
        let cleanString = carModel.dailyCost.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")
        return Double(cleanString) ?? 0.0
    }
    
    var taxes: Double {
        let taxRate = 0.0825
        let feeRate = 0.05
        let total = subtotal
        return roundToTwoDecimalPlaces((taxRate * total) + (feeRate * total))
    }
    
    var totalCost: Double {
        return roundToTwoDecimalPlaces(subtotal + taxes)
    }
    
    private func roundToTwoDecimalPlaces(_ value: Double) -> Double {
        return (value * 100).rounded() / 100
    }
    
    var body: some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
        
        ZStack {
            Color(hex: "1C1C1E")
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                if orientation.isPortrait(device: .iPhone) {
                    topBarView()
                    
                    Text("Checkout")
                        .foregroundStyle(.white)
                        .font(.system(size: 20, weight: .bold))
                        .padding(.vertical, 20)
                    
                    HStack(spacing: 0) {
                        Image(carModel.images[0])
                            .resizable()
                            .scaledToFit()
                        VStack(alignment: .leading) {
                            Text(carModel.carName)
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundColor(.white)
                            Text("Exterior: " + carModel.exterior)
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            Text("Interior: " + carModel.interior)
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            Text("Performance: " + carModel.engine)
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .background(Color(hex: "2F2F31"))
                    .cornerRadius(5)
                    .padding(.horizontal)
                    .padding(.vertical, 15)
                    
                    VStack {
                        CostSummaryRow(
                            leftText: "\(distance) Miles",
                            rightText: String(format: "%.2f", subtotal),
                            color: Color(.systemGray)
                        )
                        CostSummaryRow(leftText: "Taxes and Fees (5%)", rightText: String(format: "%.2f", taxes), color: Color(.systemGray))
                        CostSummaryRow(leftText: "Total", rightText: String(format: "%.2f", totalCost), color: .white)
                    }
                    .padding(.vertical, 30)
                    
                    Spacer()
                    
                    VStack {
                        // Display the selected card (or first card if none selected)
                        if let card = selectedCard ?? userCards.first {
                            Button(action: {
                                showCardPicker = true // Show the card picker sheet when clicked
                            }) {
                                CardCheckout(
                                    cardType: card.cardType,
                                    cardNumber: card.cardNumber,
                                    expDate: card.expDate,
                                    securityPin: card.securityPin
                                )
                            }
                        } else {
                            // No cards available, show "Add Payment Method" button
                            Button(action: {
                                selectedCard = Card(
                                    id: nil,
                                    cardNumber: "",
                                    cardType: "",
                                    expDate: "",
                                    securityPin: ""
                                )
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    showCardPicker = true
                                    showAddPayment = true
                                }
                            }) {
                                AddRow(label: "Add Payment Method")
                            }
                        }
                        
                        if let card = selectedCard ?? userCards.first {
                            let cardFormatted = Card(
                                cardNumber: "****\(card.cardNumber.suffix(4))",
                                cardType: card.cardType,
                                expDate: card.expDate,
                                securityPin: "****"
                            )
                            
                            NavigationLink(
                                destination: RidesConfirmationView(
                                    carModel: carModel,
                                    destination: destination,
                                    origin: origin,
                                    totalCost: totalCost,
                                    selectedCard: cardFormatted,
                                    navigationPath: $navigationPath
                                )
                                .navigationBarBackButtonHidden(true)
                                .toolbar(.hidden, for: .tabBar),
                                isActive: $navigateToConfirmation
                                
                            ) {
                                EmptyView()
                            }
                        }
                        Button(action: {
                            guard let card = selectedCard ?? userCards.first else {
                                errorMessage = "Please select a card before confirming."
                                showAlert = true
                                return
                            }
                            
                            if card.cardType.isEmpty || card.cardNumber.isEmpty {
                                errorMessage = "The selected card is incomplete. Please choose a valid card or add a new one."
                                showAlert = true
                                return
                            }
                            
                            saveRideDetails(
                                carModel: carModel,
                                image: carModel.images[0],
                                arrivalTime: arrivalTime,
                                totalCost: totalCost,
                                selectedCard: card
                            )
                            navigateToConfirmation = true
                        }) {
                            Text("Confirm Ride")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, maxHeight: 41)
                                .background(Color(hex: "D9D9D9"))
                                .cornerRadius(5)
                                .padding(.horizontal, 25)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Error"),
                                message: Text(errorMessage),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                    .padding(.top, 15)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "101011"))
                }
                
                else if orientation.isLandscape(device: .iPhone) {
                    
                }
            }
            .onAppear{
                fetchUserCards()
            }
            .sheet(isPresented: $showCardPicker) {
                ZStack {
                    Color(hex:"101011")
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        SectionHeader(title: "Payment Methods")
                        
                        ForEach(userCards, id: \.id) { card in
                            Button(action: {
                                selectedCard = card
                                showCardPicker = false
                            }) {
                                CardRow(
                                    cardType: card.cardType,
                                    cardNumber: card.cardNumber,
                                    expDate: card.expDate,
                                    securityPin: card.securityPin
                                )
                            }
                        }
                        
                        Button(action: {
                            selectedCard = Card(
                                id: nil,
                                cardNumber: "",
                                cardType: "",
                                expDate: "",
                                securityPin: ""
                            )
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                               showAddPayment = true
                           }
                        }) {
                            AddRow(label: "Add Payment Method")
                        }
                    }
                    .cornerRadius(12)
                }
                .presentationDetents([.height(250)])
                
                .sheet(isPresented: $showAddPayment) {
                    if let card = selectedCard {
                        CardDetailsSheet(card: card)
                            .environment(\.colorScheme, .dark)
                            .onDisappear {
                                fetchUserCards()
                            }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(Color(hex: "999999"))
                            .padding(.leading)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("RIDE")
                        .font(.system(size: 24, weight: .black))
                        .foregroundStyle(Color(.white))
                }
            }
        }
    }
}
