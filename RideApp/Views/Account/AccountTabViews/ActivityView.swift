//
//  ActivityView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/3/24.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI

struct ActivityView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass:
        UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass:
        UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode

    private let db = Firestore.firestore()  // Firestore instance
    @State private var rentals: [Rental] = []  // Store rentals fetched from Firestore
    @State private var rides: [Ride] = []  // Store rides fetched form Firestore
    @State private var isLoading = true
    @State private var showingFilterView = false
    @State private var showingSortView = false
    @State private var selectedSort: SortOption = SortOption(
        title: "Most Recent")
    @State private var selectedCarType: String = "All"
    @State private var selectedTimeFrame: String = "All"
    @State private var selectedRentalType: String = "All"

    @State private var navigationPath = NavigationPath()

    private var filteredRentals: [Rental] {
        switch selectedSort.title {
        //                Recent Pickup asc/dec
        case (title:"Most Recent"):
            return rentals.sorted { $0.pickupDate < $1.pickupDate }
        case (title:"Least Recent"):
            return rentals.sorted { $0.pickupDate > $1.pickupDate }
        //                Name Alphabetical asc/dec
        case "Alphabetical (Ascending)":
            return rentals.sorted { $0.carModel.carName > $1.carModel.carName }
        case "Alphabetical (Descending)":
            return rentals.sorted { $0.carModel.carName < $1.carModel.carName }
        //                Price asc/dec
        case "Price (Ascending)":
            return rentals.sorted {
                $0.totalCost > $1.totalCost
            }
        case "Price (Descending)":
            return rentals.sorted {
                $0.totalCost < $1.totalCost
            }
        default:  // Best Match
            return rentals
        }
    }

    private var filteredRides: [Ride] {
        switch selectedSort.title {
        //                Recent Pickup asc/dec
        case (title:"Most Recent"):
            return rides.sorted { $0.arrivalTime < $1.arrivalTime }
        case (title:"Least Recent"):
            return rides.sorted { $0.arrivalTime > $1.arrivalTime }
        //                Name Alphabetical asc/dec
        case "Alphabetical (Ascending)":
            return rides.sorted { $0.carModel.carName > $1.carModel.carName }
        case "Alphabetical (Descending)":
            return rides.sorted { $0.carModel.carName < $1.carModel.carName }
        //                Price asc/dec
        case "Price (Ascending)":
            return rides.sorted {
                $0.totalCost > $1.totalCost
            }
        case "Price (Descending)":
            return rides.sorted {
                $0.totalCost < $1.totalCost
            }
        default:  // Best Match
            return rides
        }
    }

    func fetchUserRentals() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No authenticated user found.")
            return
        }

        db.collection("user_rentals")
            .whereField("userId", isEqualTo: currentUser.uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    //                    print("Error fetching rentals: \(error.localizedDescription)")
                } else if let documents = snapshot?.documents {
                    //                    print("Fetched \(documents.count) rentals for user: \(currentUser.uid)")

                    documents.forEach { document in
                        //                        print("Rental Document ID: \(document.documentID), Data: \(document.data())")
                    }

                    let rentals = documents.compactMap { doc -> Rental? in
                        do {
                            let rental = try doc.data(as: Rental.self)
                            //                            print("Decoded Rental: \(rental)") // Log each decoded rental
                            return rental
                        } catch let decodingError {
                            // Log the full error object and associated info
                            //                            print("Error decoding rental: \(decodingError.localizedDescription)")
                            //                            print("Error details: \(decodingError)")  // This will print more detailed information about the decoding error
                            return nil
                        }
                    }

                    self.rentals = rentals
                    //                    print("Updated Rentals Array: \(rentals)")
                } else {
                    //                    print("No rentals found for user: \(currentUser.uid)")
                }
            }
    }

    func fetchUserRides() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No authenticated user found.")
            return
        }

        db.collection("user_rides")
            .whereField("userId", isEqualTo: currentUser.uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching rides: \(error.localizedDescription)")
                } else if let documents = snapshot?.documents {
                    //                    print("Fetched \(documents.count) rentals for user: \(currentUser.uid)")

                    //                    documents.forEach { document in
                    //                        print("Rental Document ID: \(document.documentID), Data: \(document.data())")
                    //                    }

                    let rides = documents.compactMap { doc -> Ride? in
                        do {
                            let ride = try doc.data(as: Ride.self)
                            return ride
                        } catch let decodingError {
                            // Log the full error object and associated info
                            print(
                                "Error decoding ride: \(decodingError.localizedDescription)"
                            )
                            print("Error details: \(decodingError)")  // This will print more detailed information about the decoding error
                            return nil
                        }
                    }

                    self.rides = rides
                } else {
                    print("No rides found for user: \(currentUser.uid)")
                }
            }
    }

    func applyFilters() {

    }

    var body: some View {
        let orientation = DeviceHelper(
            widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)

        NavigationStack(path: $navigationPath) {
            ZStack {
                Color(hex: "1C1C1E")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if orientation.isPortrait(device: .iPhone) {
                        ZStack {
                            HStack {
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Image(systemName: "chevron.backward")
                                        .foregroundStyle(Color(hex: "999999"))
                                        .padding(.leading)
                                }
                                Spacer()

                            }

                            Text("Activity")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(.white)

                        }

                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.clear)
                        .background(Color(hex: "1C1C1E"))

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
                                    Image(
                                        systemName: "arrow.up.arrow.down.square"
                                    )
                                    Text("Sort")
                                }
                                .frame(maxWidth: .infinity, maxHeight: 30)
                                .background(Color(hex: "303033"))
                                .cornerRadius(0)
                                .foregroundColor(.white)
                            }
                        }
                        .shadow(
                            color: Color(
                                red: 0, green: 0, blue: 0, opacity: 0.25),
                            radius: 10, y: 10
                        )
                        Spacer()

                        if isLoading {
                            ProgressView()
                        } else if rentals.isEmpty && rides.isEmpty {
                            Text("No rides or rentals found")
                                .foregroundColor(.white)
                            Spacer()
                        } else {

                            ScrollView {
                                if !rentals.isEmpty {
                                    Text("Rentals")
                                        .font(.headline)
                                        .padding(.horizontal)
                                        .foregroundStyle(.white)
                                        .multilineTextAlignment(.leading)
                                    
                                    ForEach(rentals) { rental in
                                        Button(action: {
                                            // Append the entire rental object to the navigation path
                                            navigationPath.append(rental)
                                        }) {
                                            RentalActivityCard(CarData: rental)
                                                .padding(.bottom, 10)
                                        }
                                    }
                                    .onDelete { IndexSet in
                                        
                                    }
                                
                                }
                                if !rides.isEmpty {
                                    Text("Rides")
                                        .font(.headline)
                                        .padding(.horizontal)
                                        .foregroundStyle(.white)
                                        .multilineTextAlignment(.leading)
                                    ForEach(rides) { ride in
                                        Button(action: {
                                            // Append the entire ride object to the navigation path
                                            navigationPath.append(ride)
                                        }) {
                                            RidesActivityCard(CarData: ride)
                                                .padding(.bottom, 10)
                                        }
                                    }
                                    .onDelete { IndexSet in
                                        
                                    }
                                }

                            }
                            .padding(.top, 20)

                        }
                    } else if orientation.isLandscape(device: .iPhone) {
                    } else {
                    }
                }
                .navigationDestination(for: Rental.self) { rental in
                    RentalConfirmationView(
                        carModel: rental.carModel,
                        pickupDate: rental.pickupDate,
                        dropoffDate: rental.dropoffDate,
                        totalCost: rental.totalCost,
                        selectedCard: rental.selectedCard,
                        navigationPath: $navigationPath
                    )
                    .navigationBarBackButtonHidden(true)
                    .toolbar(.hidden, for: .tabBar)
                }
                .navigationDestination(for: Ride.self) { ride in
                    RidesConfirmationView(
                        carModel: ride.carModel,
                        destination: ride.destinationAddress,
                        origin: ride.originAddress,
                        totalCost: ride.totalCost,
                        selectedCard: ride.selectedCard,
                        navigationPath: $navigationPath
                    )
                    .navigationBarBackButtonHidden(true)
                    .toolbar(.hidden, for: .tabBar)
                }

            }

        }
        .onAppear {
            fetchUserRentals()  // Fetch rentals and rides when the view appears
            fetchUserRides()
            isLoading = false
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Image(systemName: "person.crop.circle.fill")
            Text("Account")
        }
        .sheet(isPresented: $showingFilterView) {
            ActivityFilterView(
                selectedCarType: $selectedCarType,
                selectedTimeFrame: $selectedTimeFrame,
                selectedRentalType: $selectedRentalType
            )
            .environment(\.colorScheme, .dark)
        }
        .sheet(isPresented: $showingSortView) {
            ActivitySortView(selectedSort: $selectedSort)
                .environment(\.colorScheme, .dark)
        }

    }
}

#Preview {
    ActivityView()
}
