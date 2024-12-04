//
//  RidesConfirmationView.swift
//  RideApp
//
//  Created by Sage Turner on 10/23/24.
//

import SwiftUI

struct RidesSummaryView: View {
    var carModel: CarDetails
    var origin: String
    var destination: String
    var totalCost: Double
    var arrivalTime: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Order Summary")
                .font(.system(size: 24, weight: .bold))
                .padding([.top, .bottom], 5)
            
            Text("Vehicle:\n" + carModel.carName)
                .font(.system(size: 12, weight: .bold))
            
            Text("Pickup Location:\n" + origin)
                .font(.system(size: 12, weight: .bold))
            
            Text("Arrival Time:\n" + arrivalTime)

            Text("Total Amount Due:\n" + "$" + String(format: "%.2f", totalCost) + " ~ " + "Apple Pay")
                .font(.system(size: 12, weight: .bold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 20)
        
        VStack(alignment: .leading, spacing: 5) {
            Text("What's Next")
                .font(.system(size: 24, weight: .bold))
                .padding(.top, 15)
                .padding(.bottom, 5)
            
            Text("Hang tight, your ride should arrive shortly.")
                .font(.system(size: 12, weight: .bold))

            Text("Please stay nearby the specified pickup location.")
                .font(.system(size: 12, weight: .bold))

            Text("Verify that the car is the same as the ordered ordered one.")
                .font(.system(size: 12, weight: .bold))
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
}


struct RidesConfirmationView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode
    var carModel: CarDetails

    var arrivalTime: String {
        let time = Date().addingTimeInterval(10 * 60).formatted(.dateTime.hour().minute())
        let string = time
        return string
    }
    var destination: String
    var origin: String
    var totalCost: Double
    @Binding var navigationPath: NavigationPath

    var body: some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
            
        ZStack {
            Color(hex: "1C1C1E")
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                if orientation.isPortrait(device: .iPhone) {
                    topBarView()
                    
                    Text("Ride Confirmed")
                        .foregroundColor(Color(.white))
                        .font(.system(size: 20, weight: .bold))
                        .padding(.top, 20)
                    
                    Image(carModel.images[0])
                        .resizable()
                        .padding(.horizontal)
                        .padding(.top, 15)
                    
                    Text("We’ve got everything ready for your upcoming ride. If we have any questions, we’ll reach out to you directly.")
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.all)
                    
                    RidesSummaryView(carModel: carModel, origin: origin, destination: destination, totalCost: totalCost, arrivalTime: arrivalTime)
                    
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
            }.foregroundStyle(.white)
            
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
