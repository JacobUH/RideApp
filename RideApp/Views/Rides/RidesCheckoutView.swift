//
//  RidesCheckoutView.swift
//  RideApp
//
//  Created by Sage Turner on 10/24/24.
//

import SwiftUI

struct RidesCheckoutView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode

    var carModel: CarDetails
    var origin: String
    var destination: String
    var subtotal: Double
    
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
                    
                    HStack(spacing: 15) {
                        VStack(alignment: .leading) {
                            Text("Pickup")
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
                    
                    HStack(spacing: 15) {
                        VStack(alignment: .leading) {
                            Text("Destination")
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundColor(.white)
                                .padding(.bottom, 10)
                            Text("Cyber Square")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            Text("1500 Velocity Drive")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            Text("Houston, TX 77002")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
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
                    VStack {
                        NavigationLink(
                            destination: RidesConfirmationView(
                                carModel: carModel, destination: destination, origin: origin,  totalCost: 100
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
