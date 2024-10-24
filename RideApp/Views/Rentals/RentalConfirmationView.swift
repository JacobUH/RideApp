//
//  RentalConfirmationView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/22/24.
//

import SwiftUI

struct OrderSummaryView: View {
    var carModel: CarDetails
    var pickup: String
    var dropoff: String
    var totalCost: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Order Summary")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
                .padding([.top, .bottom], 5)
            
            Text("Vehicle:\n" + carModel.carName)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
            
            Text("Pickup Location:\n" + "Ride Plaza, 1500 Velocity Drive, Houston, TX 77002")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
            
            Text("Pickup Date:\n" + pickup)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
            
            Text("Dropoff Date:\n" + dropoff)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)

            Text("Total Amount:\n" + "$" + String(totalCost) + " ~ " + "Apple Pay")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 20)
        
        VStack(alignment: .leading, spacing: 5) {
            Text("What's Next")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
                .padding(.top, 15)
                .padding(.bottom, 5)
            
            Text("You’ll receive a reminder 24 hours before your pickup.")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)

            Text("Please arrive at Ride Plaza at your scheduled time.")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)

            Text("Bring your valid ID for a smooth handoff.")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
}


struct RentalConfirmationView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode
    var carModel: CarDetails
    
    var pickupDate: Date
    var pickup: String {
        let day = pickupDate.formatted(.dateTime.year().month(.abbreviated).day())
        let time = pickupDate.formatted(.dateTime.hour().minute())
        let string = day + ", " + time
        return string
    }
    
    var dropoffDate: Date
    var dropoff: String {
        let day = dropoffDate.formatted(.dateTime.year().month(.abbreviated).day())
        let time = dropoffDate.formatted(.dateTime.hour().minute())
        let string = day + ", " + time
        return string
    }
    
    var totalCost: Double
    @Binding var navigationPath: NavigationPath // Add this binding

    var body: some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
            
        ZStack {
            Color(hex: "1C1C1E")
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                if orientation.isPortrait(device: .iPhone) {
                    topBarView()
                    
                    Text("Rental Confirmed")
                        .foregroundColor(Color(.white))
                        .font(.system(size: 20, weight: .bold))
                        .padding(.top, 20)
                    
                    Image(carModel.images[0])
                        .resizable()
                        .padding(.horizontal)
                        .padding(.top, 15)
                    
                    Text("We’ve got everything ready for your upcoming ride. If we have any questions, we’ll reach out to you directly.")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.all)
                    
                    OrderSummaryView(carModel: carModel, pickup: pickup, dropoff: dropoff, totalCost: totalCost)
                    
                    Spacer()
                    VStack {
                        Button(action: {
                            navigationPath = NavigationPath()

                        }) {
                            Text("Continue")
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
            ToolbarItem(placement: .principal) {
                Text("RIDE")
                    .font(.system(size: 24, weight: .black))
                    .foregroundStyle(Color(.white))
            }
        }
    }
}
