//
//  HomeView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/1/24.
//

import SwiftUI

struct HomeView: View {    
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @State private var carList: [CarDetails] = []
    @State private var filteredPopularCars: [CarDetails] = []
    @State private var filteredNearbyCars: [CarDetails] = []
    @State private var navigationPath = NavigationPath()
    
    @State public var destinationAddress: String = ""
    @State public var originAddress: String = "13418 Misty Orchard Ln"
    @State public var driveTime: String = "Next Stop?"
    
    enum CarType: Hashable {
        case popular(CarDetails)
        case nearby(CarDetails)
    }
    
    func loadCarData() {
        if let jsonData = CarData.jsonString.data(using: .utf8) {
            do {
                let decodedData = try JSONDecoder().decode(CarList.self, from: jsonData)
                carList = decodedData.cars
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }
    }
    
    func filterPopularCars() {
        filteredPopularCars = carList.filter { car in
            car.carName == "Herrera Riptide - Terrier" || car.carName == "Archer Quartz - Bandit" || car.carName == "Chevillion Thrax - Jefferson"
        }
    }
    
    func filterNearbyCars() {
        filteredNearbyCars = carList.filter { car in
            car.carName == "Cortes V5000 Valor" || car.carName == "Archer Quartz EC-L" || car.carName == "Quadra Sport R-7"
        }
    }
    
    var body: some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
        
        NavigationStack(path: $navigationPath){
            ZStack {
                Color(hex: "1C1C1E")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if orientation.isPortrait(device: .iPhone) {
                        ZStack {
                            Image("homeBanner")
                                .resizable()
                                .scaledToFit()
                            VStack (alignment: .leading ,spacing: 0){
                                Text("Ride Into")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                                Text("Tomorrow")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(Color(hex: "4FA0FF"))
                            }
                            .offset(x:-80, y:0)
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Popular Rentals")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            HStack (spacing: 0) {
                                Text("Or check out all our")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.white)
                                Text(" rentals here")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(Color(hex: "4FA0FF"))
                            }
                          
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 1).padding(.leading)

                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 15) {
                                ForEach(filteredPopularCars, id: \.self) { car in
                                    Button {
                                        navigationPath.append(CarType.popular(car))
                                    } label: {
                                        VStack {
                                            Image(car.images[0])
                                                .resizable()
                                                .frame(width: 250, height: 140)
                                            ZStack {
                                                Text(car.carName)
                                                    .font(Font.custom("SF Pro", size: 12))
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                Text("$\(car.dailyCost)/day")
                                                    .font(Font.custom("SF Pro", size: 12))
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                            }
                                            .padding(.vertical, 2)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)


                        VStack(alignment: .leading, spacing: 3) {
                          Text("Nearby Rides")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            HStack (spacing: 0) {
                                Text("Or find a driver to get you a")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.white)
                                Text(" ride here")
                                      .font(.system(size: 12, weight: .regular))
                                      .foregroundColor(Color(hex: "4FA0FF"))
                            }
                          
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 10).padding(.leading)
                         
                        ScrollView(.horizontal) {
                            HStack(spacing: 15) {
                                ForEach(filteredNearbyCars, id: \.self) { car in
                                    Button {
                                        navigationPath.append(CarType.nearby(car))
                                    } label: {
                                        VStack {
                                            Image(car.images[0])
                                                .resizable()
                                                .frame(width: 250, height: 140)
                                            ZStack {
                                                Text(car.carName)
                                                    .font(Font.custom("SF Pro", size: 12))
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                Text("$\(car.dailyCost)/day")
                                                    .font(Font.custom("SF Pro", size: 12))
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                            }
                                            .padding(.vertical, 2)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    else if orientation.isLandscape(device: .iPhone){}
                    else {}
                }
                .onAppear {
                    loadCarData()
                    filterPopularCars()
                    filterNearbyCars()
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("RIDE")
                            .font(.system(size: 24, weight: .black))
                            .foregroundStyle(.white)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: CarType.self) { carType in
                    switch carType {
                    case .popular(let car):
                        RentalDetailView(carModel: car, navigationPath: $navigationPath)
                            .navigationBarBackButtonHidden(true)
                            .toolbar(.hidden, for: .tabBar)
                        
                    case .nearby(let car):
                        RidesDetailView(
                            distanceCost: 100.00,
                            origin: originAddress,
                            destinaiton: destinationAddress,
                            carModel: car,
                            navigationPath: $navigationPath
                        )
                            .navigationBarBackButtonHidden(true)
                            .toolbar(.hidden, for: .tabBar)
                    }
                }

            }
           
        }
        
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Image(systemName: "house.fill")
            Text("Home")
        }
        
        
        
    }
}

#Preview {
    HomeView()
}
