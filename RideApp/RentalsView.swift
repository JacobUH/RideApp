//
//  RentalsView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/1/24.
//

import SwiftUI

// going to make a placeholder for the herrrera now
let carModel = CarDetails(
    carName: "Herrera Riptide - Terrier",
    interior: "Brown",
    exterior: "White/Silver",
    engine: "8-speed automatic with manual shift",
    horsepower: "500 HP",
    mileage: "30 MPG (Hybrid mode), 50 miles on pure electric",
    transmission: "8-speed automatic with manual paddle shift option",
    driveType: "All-Wheel Drive (AWD)",
    
    // Features
    entertainment: "Surround sound audio system\n12\" holographic display",
    convenience: "AI-integrated voice command system\nAdvanced climate control",
    packages: "Customizable ambient lighting\nSpacious, ergonomic seating with heating and cooling",
    
    // stuctures
    images: ["herreraRiptideRental", "herreraRiptideRental2", "herreraRiptideRental3", "herreraRiptideRental4"],
    dailyCost: "74"
)

// Reusable top bar view
    @ViewBuilder
    private func topBarView() -> some View {
        HStack (spacing: 1) {
            Spacer()
        }
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity)
        .foregroundColor(.clear)
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .shadow(
          color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 10, y: 10
        )
    }

struct CarCard: View {
    let imageName: String
    let CarName: String
    let dailyCost: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                Image(imageName)
                    .resizable()
                    .frame(height: 220)
                HStack {
                    Text(CarName)
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.leading, 10)
                    Spacer()
                    Text("$" + dailyCost + "/day")
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.trailing, 10)
                }
                .padding(.vertical, 10)
                
            }
        }
        .background(Color(red: 0.19, green: 0.19, blue: 0.2))
        .cornerRadius(5)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        .frame(maxWidth: .infinity, minHeight: 270)
        .padding([.leading, .trailing], 15)
    }
}

struct RentalsView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    
    @State private var searchText: String = ""
    @State private var isTabBarVisible: Bool = true

    var body: some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
        
        NavigationView(content: {
            ZStack {
                Color(hex: "1C1C1E")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if orientation.isPortrait(device: .iPhone) {
                        HStack (spacing: 1) {
                            Button(action: {
                                // Filter action
                            }) {
                                HStack {
                                    
                                    Image(systemName: "slider.horizontal.3")
                                    Text("Filter")
                                }
                                .frame(maxWidth: .infinity, maxHeight: 30)
                                .background(Color(hex: "303033"))
                                .cornerRadius(0)
                                .foregroundColor(.white)
                            }
                            Button(action: {
                                // Sort action
                            }) {
                                HStack {
                                    
                                    Image(systemName: "arrow.up.arrow.down.square")
                                    Text("Sort")
                                }
                                .frame(maxWidth: .infinity, maxHeight: 30)
                                .background(Color(hex: "303033"))
                                .cornerRadius(0)
                                .foregroundColor(.white)
                            }
                        }
                        .padding(.bottom, 20)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.clear)
                        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                        .shadow(
                          color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 10, y: 10
                        )
                        
                        ScrollView {
                            NavigationLink(
                                destination: CarDetailView()
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .tabBar)
                            ) {
                                CarCard(imageName: carModel.images[0], CarName: carModel.carName, dailyCost: carModel.dailyCost)
                            }

                            CarCard(imageName: "quadraType66Rental", CarName: "Quadra Type 66 - Avenger", dailyCost: "68")
                            CarCard(imageName: "thortonColbyRental", CarName: "Thorton Colby CX410", dailyCost: "25")
                            CarCard(imageName: "mizutaniHozukiRental", CarName: "Mizutani Hozuki", dailyCost: "32")
                            CarCard(imageName: "mizutaniShionRental", CarName: "Mizutani Shion", dailyCost: "39")
                        }
                        .padding(.top)
                        
                        Spacer()
                    }
                    else if orientation.isLandscape(device: .iPhone){}
                    else {}
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("RIDE")
                            .font(.system(size: 24, weight: .black))
                            .foregroundStyle(Color(.white))
                    }
                }
                .navigationBarTitleDisplayMode(.inline)

            }
           
        })
        .searchable(text: $searchText)
        .foregroundStyle(Color(.white))
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Image(systemName: "car")
            Text("Rentals")
        }
        
        
    }
}

struct DetailRow: View {
    var label, desc: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(label)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .alignmentGuide(.firstTextBaseline) { d in d[.top] }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)

                Text(desc)
                    .font(.system(size: 13))
                    .alignmentGuide(.firstTextBaseline) { d in d[.top] } // Align desc to the top as well
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                Spacer()
            }
            .padding(.vertical, 3)
            Divider()
                .background(Color.gray)
        }
    }
}

struct CarDetailView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode
    
    @State private var currentImageIndex = 0
    
    var body : some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
        
        NavigationView(content: {
            ZStack {
                Color(hex: "1C1C1E")
                    .edgesIgnoringSafeArea(.all)
                VStack (spacing: 0) {
                    if orientation.isPortrait(device: .iPhone) {
                        topBarView()
                        
                        // we will need to use actual JSON retrieved dataModels here later
                        ScrollView {
                            Text(carModel.carName)
                                .font(.system(size: 20 , weight: .bold))
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
                            
                            VStack (spacing: 30) {
                                VStack (alignment: .leading) {
                                    Text("Specfications")
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
                                VStack (alignment: .leading) {
                                    Text("Features")
                                        .font(.system(size: 24, weight: .bold))
                                        .padding(.leading).padding(.bottom, 10)
                                    DetailRow(label: "Entertainment", desc: carModel.entertainment)
                                    DetailRow(label: "Convenience", desc: carModel.convenience)
                                    DetailRow(label: "Packages", desc: carModel.packages)
                                }
                            }
                            .offset(y: -60)
                        }
                        HStack {
                            HStack {
                                Text("$" + carModel.dailyCost + "/day \nTax included at checkout")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.leading, 25)
                                Spacer()
                                
                                Button(action: {
                                    // Action for the button
                                }) {
                                    
                                      Text("Continue")
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                        .frame(width: 160, height: 41)
                                        .background(Color(hex: "D9D9D9"))
                                        .cornerRadius(5)
                                }
                                .padding(.trailing, 25)
                            }
                            .padding(.top, 15)
                        }
                        .frame(height: 50)

                        .background(Color(hex: "101011"))
                    }
                    else if orientation.isLandscape(device: .iPhone) {}
                }
                
            }
        })
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
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RentalsView()
}
