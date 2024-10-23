//
//  RentalsView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/1/24.
//

import SwiftUI

struct RentalsView: View {
    @State private var searchText: String = ""
    @State private var carList: [CarDetails] = []
    
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
    
    var filteredCars: [CarDetails] {
        if searchText.isEmpty {
            return carList
        } else {
            return carList.filter { $0.carName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "1C1C1E").edgesIgnoringSafeArea(.all)
                
                VStack {
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
                        ForEach(filteredCars, id: \.carName) { car in
                            NavigationLink(
                                destination: RentalDetailView(carModel: car)
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .tabBar)
                            ) {
                                CarCard(imageName: car.images[0], CarName: car.carName, dailyCost: car.dailyCost)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("RIDE")
                            .font(.system(size: 24, weight: .black))
                            .foregroundColor(.white)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                
            }
        }
        .onAppear {
            loadCarData()
        }
        .searchable(text: $searchText)
        .foregroundStyle(Color(.white))
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Image(systemName: "car")
            Text("Rentals")
        }
    }
    
    
}

#Preview {
    RentalsView()
}
