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
    @State private var navigationPath = NavigationPath()
    
    // sort states
    @State private var showingSortView = false
    @State private var selectedSort: SortOption? = SortOption(title: "Best Match")
    
    // filter states (gonna add more soon)
    @State private var showingFilterView = false
    @State private var selectedCarType: String = "All"
    @State private var minPrice: String = ""
    @State private var maxPrice: String = ""

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
        let filteredBySearch = searchText.isEmpty ? sortedCars : sortedCars.filter { $0.carName.localizedCaseInsensitiveContains(searchText) }
        
        let minPriceValue = Double(minPrice) ?? 0
        let maxPriceValue = Double(maxPrice) ?? Double.greatestFiniteMagnitude
        
        return filteredBySearch.filter { car in
            let carCost = Double(car.dailyCost) ?? 0

            return (selectedCarType == "All" || car.carType == selectedCarType) &&
                   (minPrice.isEmpty || carCost >= minPriceValue) &&
                   (maxPrice.isEmpty || carCost <= maxPriceValue)
        }
    }

    var sortedCars: [CarDetails] {
        guard let sortOption = selectedSort else {
            return carList
        }
        switch sortOption.title {
        case "Alphabetical (Ascending)":
            return carList.sorted { $0.carName < $1.carName }
        case "Alphabetical (Descending)":
            return carList.sorted { $0.carName > $1.carName }
            
        case "Lowest Price":
            return carList.sorted {
                (Double($0.dailyCost) ?? 0) < (Double($1.dailyCost) ?? 0)
            }
        case "Highest Price":
            return carList.sorted {
                (Double($0.dailyCost) ?? 0) > (Double($1.dailyCost) ?? 0)
            }
        case "Lowest Horsepower":
            return carList.sorted {
                (Int($0.horsepower.replacingOccurrences(of: " HP", with: "")) ?? 0) <
                (Int($1.horsepower.replacingOccurrences(of: " HP", with: "")) ?? 0)
            }
        case "Highest Horsepower":
            return carList.sorted {
                (Int($0.horsepower.replacingOccurrences(of: " HP", with: "")) ?? 0) >
                (Int($1.horsepower.replacingOccurrences(of: " HP", with: "")) ?? 0)
            }
        case "Lowest Mileage":
            return carList.sorted {
                (Double($0.mileage.replacingOccurrences(of: " MPG", with: "")) ?? 0) <
                (Double($1.mileage.replacingOccurrences(of: " MPG", with: "")) ?? 0)
            }
        case "Highest Mileage":
            return carList.sorted {
                (Double($0.mileage.replacingOccurrences(of: " MPG", with: "")) ?? 0) >
                (Double($1.mileage.replacingOccurrences(of: " MPG", with: "")) ?? 0)
            }
        default: // Best Match
            return carList
        }
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color(hex: "1C1C1E").edgesIgnoringSafeArea(.all)

                VStack {
                    VStack {
                        HStack(spacing: 1) {
                            Button(action: {
                                showingFilterView.toggle()
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
                                showingSortView.toggle()
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
                        Text(filteredResultsText)
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                            .padding(.top, 10)
                    }
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.clear)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 10, y: 10)

                    ScrollView {
                        ForEach(filteredCars, id: \.carName) { car in
                            Button {
                                navigationPath.append(car)
                            } label: {
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
                .navigationDestination(for: CarDetails.self) { car in
                    RentalDetailView(carModel: car, navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden(true)
                        .toolbar(.hidden, for: .tabBar)
                }
            }
        }
        .onAppear {
            loadCarData()
        }
        .searchable(text: $searchText, prompt: "Search for rentals...")
        .foregroundStyle(Color(.white))
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Image(systemName: "car")
            Text("Rentals")
        }
        .sheet(isPresented: $showingFilterView) {
            FilterView(selectedCarType: $selectedCarType, minPrice: $minPrice, maxPrice: $maxPrice)
                .environment(\.colorScheme, .dark)
        }
        .sheet(isPresented: $showingSortView) {
            SortView(selectedSort: $selectedSort)
                .environment(\.colorScheme, .dark)
        }
    }
    private var filteredResultsText: String {
        let filterApplied = selectedCarType != "All" || !minPrice.isEmpty || !maxPrice.isEmpty
        let resultText = "\(filteredCars.count) Results"
        
        if filterApplied {
            return resultText + " (Filters Applied) • \(selectedSort?.title ?? "Sort by")"
        } else {
            return resultText + " • \(selectedSort?.title ?? "Sort by")"
        }
    }
}

#Preview {
    RentalsView()
}
