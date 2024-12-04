//
//  RentalCheckoutView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/22/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RentalCheckoutView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode

    private let db = Firestore.firestore() // Firestore instance

    var carModel: CarDetails
    var pickupDate: Date
    var dropoffDate: Date
    @Binding var navigationPath: NavigationPath // Add this binding
//    @State private var navigateToConfirmation = false
    @State private var errorMessage = ""
    
    func saveRentalDetails(carModel: CarDetails, image: String, pickupDate: Date, dropoffDate: Date, totalCost: Double) {
        guard let currentUser = Auth.auth().currentUser else {
            errorMessage = "No authenticated user found. Please log in first."
            return
        }

        // Convert the CarDetails object to a dictionary
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

        // Create the rental data dictionary
        let rentalData: [String: Any] = [
            "carModel": carModelData,
            "image": image,
            "pickupDate": Timestamp(date: pickupDate),
            "dropoffDate": Timestamp(date: dropoffDate),
            "totalCost": totalCost,
            "userId": currentUser.uid,
            "userEmail": currentUser.email ?? "Unknown"
        ]

        // Save the rental to Firestore
        db.collection("user_rentals").addDocument(data: rentalData) { error in
            if let error = error {
                print("Error saving rental data: \(error.localizedDescription)")
                errorMessage = "Error saving rental data: \(error.localizedDescription)"
            } else {
                print("Rental data saved successfully")
            }
        }
    }

    
    var dailyCost: Double {
        let cleanString = carModel.dailyCost.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")
        return Double(cleanString) ?? 0.0
    }

    var numberOfDays: Int {
        return Calendar.current.dateComponents([.day], from: pickupDate, to: dropoffDate).day ?? 0
    }

    var totalDaysCost: Double {
        return (Double(numberOfDays) * dailyCost).rounded()
    }

    var taxes: Double {
        let taxRate = 0.0825
        let feeRate = 0.05
        let total = totalDaysCost
        return roundToTwoDecimalPlaces((taxRate * total) + (feeRate * total))
    }

    var totalCost: Double {
        return roundToTwoDecimalPlaces(totalDaysCost + taxes)
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
                        .foregroundColor(Color(.white))
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
                    
                    HStack(spacing: 15) {
                        VStack(alignment: .leading) {
                            Text("Pickup Location")
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundColor(.white)
                                .padding(.bottom, 10)
                            Text("Ride Plaza")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            Text("1500 Velocity Drive")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            Text("Houston, TX 77002")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        Spacer()
                        Image("ridePlaza")
                            .resizable()
                            .scaledToFit()
                        
                    }
                    .background(Color(hex: "2F2F31"))
                    .cornerRadius(5)
                    .padding(.horizontal)
                    .padding(.vertical, 15)

                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Pickup Date")
                                .font(.system(size: 16))
                                .foregroundStyle(.white)
                           Text(pickupDate.formatted(.dateTime.year().month(.abbreviated).day()))
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color(.blue))
                            Text(pickupDate.formatted(.dateTime.hour().minute()))
                                .font(.system(size: 15))
                                .foregroundStyle(.white)
                        }
                        .padding(.leading)
                        Spacer()
                        
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(Color(hex: "999999"))
                            .padding()
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Dropoff Date")
                                .font(.system(size: 16))
                                .foregroundStyle(.white)
                            Text(dropoffDate.formatted(.dateTime.year().month(.abbreviated).day()))
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color(.blue))
                            Text(dropoffDate.formatted(.dateTime.hour().minute()))
                                .font(.system(size: 15))
                                .foregroundStyle(.white)
                        }
                        .padding(.trailing)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color(hex: "212123"))
                    .padding(.horizontal)
                    .padding(.vertical, 15)
                    
                    VStack {
                        CostSummaryRow(leftText: "\(numberOfDays) Days", rightText: String(format: "%.2f", totalDaysCost), color: Color(.systemGray))
                        CostSummaryRow(leftText: "Taxes and Fees (5%)", rightText: String(format: "%.2f", taxes), color: Color(.systemGray))
                        CostSummaryRow(leftText: "Total", rightText: String(format: "%.2f", totalCost), color: .white)
                    }
                    .padding(.vertical, 30)
                    
                    Spacer()
                    
                    VStack {
                        NavigationLink(
                            destination: RentalConfirmationView(
                                carModel: carModel,
                                pickupDate: pickupDate,
                                dropoffDate: dropoffDate,
                                totalCost: totalCost,
                                navigationPath: $navigationPath
                            )
                            .navigationBarBackButtonHidden(true)
                            .toolbar(.hidden, for: .tabBar)
                        ) {
                            EmptyView() // Empty view for the NavigationLink
                        }
                        Button(action: {
                            saveRentalDetails(
                                carModel: carModel,
                                image: carModel.images[0],
                                pickupDate: pickupDate,
                                dropoffDate: dropoffDate,
                                totalCost: totalCost
                            )
                        }) {
                            Text("Confirm Rental Reservation")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, maxHeight: 41)
                                .background(Color(hex: "D9D9D9"))
                                .cornerRadius(5)
                                .padding(.horizontal, 25)
                        }
                    }
                    .padding(.top, 15)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "101011"))


                }
                
                else if orientation.isLandscape(device: .iPhone) {}
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
