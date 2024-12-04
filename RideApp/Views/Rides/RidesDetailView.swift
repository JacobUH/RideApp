//
//  RideConfirmationView.swift
//  RideApp
//
//  Created by Sage Turner on 10/23/24.
//

import SwiftUI

struct RidesDetailView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode
    
    @State private var currentImageIndex = 0
    var distanceCost: Double
    var origin: String
    var destinaiton: String
    
    var carModel: CarDetails
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
       
            ZStack {
                Color(hex: "1C1C1E")
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 0) {
                    if orientation.isPortrait(device: .iPhone) {
                        topBarView()
                        
                        ScrollView {
                            Text(carModel.carName)
                                .foregroundColor(Color(.white))
                                .font(.system(size: 20, weight: .bold))
                                .padding(.vertical, 10)
                            
                            ZStack {
                                TabView(selection: $currentImageIndex) {
                                    ForEach(0..<carModel.images.count, id: \.self) { index in
                                        Image(carModel.images[index])
                                            .resizable()
                                            .scaledToFit()
                                            .padding([.leading, .trailing])
                                            .tag(index)
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                                .frame(height: 300)
                                .offset(y: -50)
                            }
                            
                            VStack(spacing: 30) {
                                VStack(alignment: .leading) {
                                    Text("Specifications")
                                        .foregroundColor(Color(.white))
                                        .font(.system(size: 24, weight: .bold))
                                        .padding(.leading).padding(.bottom, 10)
                                    
                                    DetailRow(label: "Interior Color", desc: carModel.interior)
                                    DetailRow(label: "Exterior Color", desc: carModel.exterior)
                                    DetailRow(label: "Engine", desc: carModel.engine)
                                    DetailRow(label: "Horsepower", desc: carModel.horsepower)
                                    DetailRow(label: "Mileage", desc: carModel.mileage)
                                    DetailRow(label: "Transmission", desc: carModel.transmission)
                                    DetailRow(label: "Drive Type", desc: carModel.driveType)
                                }
                                VStack(alignment: .leading) {
                                    Text("Features")
                                        .foregroundColor(Color(.white))
                                        .font(.system(size: 24, weight: .bold))
                                        .padding(.leading).padding(.bottom, 10)
                                    
                                    DetailRow(label: "Entertainment", desc: carModel.features.entertainment)
                                    DetailRow(label: "Convenience", desc: carModel.features.convenience)
                                    DetailRow(label: "Packages", desc: carModel.features.packages)
                                }
                            }
                            .offset(y: -60)
                        }
                        Spacer()
                        HStack {
                            Text("$" +  String(format: "%.2f", distanceCost) + "\nTax included at checkout")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.leading, 25)
                            Spacer()
                            
                            NavigationLink(
                                destination: RidesCheckoutView(
                                    carModel: carModel,
                                    origin: origin,
                                    destination: destinaiton,
                                    subtotal: distanceCost,
                                    arrivalTime: Date(),
                                    navigationPath: $navigationPath
                                )
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .tabBar)
                            ) {
                                Text("Continue")
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
