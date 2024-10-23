//
//  RentalDateView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/22/24.
//

import SwiftUI

struct RentalDateView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode

    @State private var pickupDate = Date()
    @State private var dropoffDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State private var isPickupSelected = true

    var carModel: CarDetails

    var body: some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
        ZStack {
            Color(hex: "1C1C1E")
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                if orientation.isPortrait(device: .iPhone) {
                    topBarView()
                    
                    Text("Select Your Dates")
                        .foregroundColor(Color(.white))
                        .font(.system(size: 20, weight: .bold))
                        .padding(.vertical, 20)
                    
                    HStack(spacing: 0) {
                        Button(action: {
                            isPickupSelected = true
                        }) {
                            Text("Pickup")
                                .frame(maxWidth: .infinity)
                                .fontWeight(isPickupSelected ? .bold : .regular)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .background(isPickupSelected ? Color.clear : Color(hex: "303033"))
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(isPickupSelected ? Color.white : Color.clear, lineWidth: 1)
                                )
                        }
                        Button(action: {
                            isPickupSelected = false
                        }) {
                            Text("Drop-off")
                                .frame(maxWidth: .infinity)
                                .fontWeight(!isPickupSelected ? .bold : .regular)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .background(!isPickupSelected ? Color.clear : Color(hex: "303033"))
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(!isPickupSelected ? Color.white : Color.clear, lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)

                    if isPickupSelected {
                        DatePicker("Pickup Date", selection: $pickupDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                            .frame(maxWidth: .infinity)
                            .labelsHidden()
                            .colorScheme(.dark)
                            .datePickerStyle(.graphical)
                            .background(Color(hex: "272728"))
                            .cornerRadius(13)
                            .padding()
                    } else {
                        DatePicker("Drop-off Date", selection: $dropoffDate, in: Calendar.current.date(byAdding: .day, value: 1, to: pickupDate)!..., displayedComponents: [.date, .hourAndMinute])
                            .colorScheme(.dark)
                            .datePickerStyle(.graphical)
                            .background(Color(hex: "272728"))
                            .cornerRadius(13)
                            .padding()
                    }
                    
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

                    Spacer()
                    HStack {
                        Text("$" + carModel.dailyCost + "/day \nTax included at checkout")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.leading, 25)
                        Spacer()
                        
                        NavigationLink(
                            destination: RentalCheckoutView(carModel: carModel, pickupDate: pickupDate, dropoffDate: dropoffDate)
                                .navigationBarBackButtonHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                        ) {
                            Text("Next")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .frame(width: 160, height: 41)
                                .background(Color(hex: "D9D9D9"))
                                .cornerRadius(5)
                                .padding(.trailing, 25)
                        }
                    }
                    .padding(.top, 15)
                    .frame(height: 50)
                    .background(Color(hex: "101011"))
                }
                
                else if orientation.isLandscape(device: .iPhone) {
                    // Handle landscape orientation if necessary
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
