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

    private let db = Firestore.firestore()

    var carModel: CarDetails
    var origin: String
    var destination: String
    var subtotal: Double
    var arrivalTime: Date
    @Binding var navigationPath: NavigationPath
    @State private var navigateToConfirmation: Bool = false
    @State private var errorMessage = ""

    func saveRideDetails(carModel: CarDetails, image: String, arrivalTime: Date, totalCost: Double) {
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

        let rideData: [String: Any] = [
            "carModel": carModelData,
            "image": image,
            "arrivalTime": Timestamp(date: arrivalTime),
            "totalCost": totalCost,
            "userId": currentUser.uid,
            "userEmail": currentUser.email ?? "Unknown"
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

    var numberOfMiles: Double = 10

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
                            leftText: "\(numberOfMiles) Miles",
                            rightText: String(format: "%.2f", subtotal),
                            color: Color(.systemGray)
                        )
                        CostSummaryRow(leftText: "Taxes and Fees (5%)", rightText: String(format: "%.2f", taxes), color: Color(.systemGray))
                        CostSummaryRow(leftText: "Total", rightText: String(format: "%.2f", totalCost), color: .white)
                    }
                    .padding(.vertical, 30)

                    Spacer()

                    NavigationLink(
                        destination: RidesConfirmationView(
                            carModel: carModel,
                            destination: destination,
                            origin: origin,
                            totalCost: totalCost,
                            navigationPath: $navigationPath
                        )
                        .navigationBarBackButtonHidden(true)
                        .toolbar(.hidden, for: .tabBar)
                    ) {
                        Text("Confirm Ride")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: 41)
                            .background(Color(hex: "D9D9D9"))
                            .cornerRadius(5)
                            .padding(.horizontal, 25)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        saveRideDetails(
                            carModel: carModel,
                            image: carModel.images[0],
                            arrivalTime: arrivalTime,
                            totalCost: totalCost
                        )
                    })
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
