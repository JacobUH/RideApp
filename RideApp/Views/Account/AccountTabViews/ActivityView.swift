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
    @State private var updatedRentals: [Rental] = []  // Store rentals fetched from Firestore
    @State private var updatedRides: [Ride] = []  // Store rides fetched form Firestore
    
    @State private var isLoading = true
    @State private var showingFilterView = false
    @State private var showingSortView = false
    @State private var selectedSort: SortOption = SortOption(
        title: "Most Recent")
    @State private var selectedCarType: String = "All"
    @State private var selectedTimeFrame: String = "All"
    @State private var selectedRentalType: String = "All"
    @State private var isFilterActive: Bool = false
    @State private var isSortActive: Bool = false

    @State private var navigationPath = NavigationPath()

    private var sortedRentals: [Rental] {
        switch selectedSort.title {
        case "Most Recent":
            return rentals.sorted { $0.pickupDate > $1.pickupDate }  // Descending
        case "Oldest":
            return rentals.sorted { $0.pickupDate < $1.pickupDate }  // Ascending
        case "Alphabetical (Ascending)":
            return rentals.sorted {
                let firstWord1 =
                    $0.carModel.carName.components(separatedBy: " ").first ?? ""
                let firstWord2 =
                    $1.carModel.carName.components(separatedBy: " ").first ?? ""
                return firstWord1 > firstWord2
            }
        case "Alphabetical (Descending)":
            return rentals.sorted {
                let firstWord1 =
                    $0.carModel.carName.components(separatedBy: " ").first ?? ""
                let firstWord2 =
                    $1.carModel.carName.components(separatedBy: " ").first ?? ""
                return firstWord1 < firstWord2
            }
        case "Price (Ascending)":
            return rentals.sorted { $0.totalCost < $1.totalCost }
        case "Price (Descending)":
            return rentals.sorted { $0.totalCost > $1.totalCost }
        default:
            return rentals  // No sorting applied
        }
    }

    private var sortedRides: [Ride] {
        switch selectedSort.title {
        case "Most Recent":
            return rides.sorted { $0.arrivalTime > $1.arrivalTime }
        case "Oldest":
            return rides.sorted { $0.arrivalTime < $1.arrivalTime }
        case "Alphabetical (Ascending)":
            return rides.sorted {
                let firstWord1 =
                    $0.carModel.carName.components(separatedBy: " ").first?
                    .lowercased() ?? ""
                let firstWord2 =
                    $1.carModel.carName.components(separatedBy: " ").first?
                    .lowercased() ?? ""
                return firstWord1 > firstWord2
            }
        case "Alphabetical (Descending)":
            return rides.sorted {
                let firstWord1 =
                    $0.carModel.carName.components(separatedBy: " ").first?
                    .lowercased() ?? ""
                let firstWord2 =
                    $1.carModel.carName.components(separatedBy: " ").first?
                    .lowercased() ?? ""
                return firstWord1 < firstWord2
            }
        case "Price (Ascending)":
            return rides.sorted { $0.totalCost < $1.totalCost }
        case "Price (Descending)":
            return rides.sorted { $0.totalCost > $1.totalCost }
        default:
            return rides
        }
    }
//    Pulls rental information from Firestore
    func fetchUserRentals() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No authenticated user found.")
            return
        }

        db.collection("user_rentals")
            .whereField("userId", isEqualTo: currentUser.uid)
            .getDocuments { snapshot, error in
                if error != nil {
                } else if let documents = snapshot?.documents {
                    documents.forEach { document in
                    }

                    let rentals = documents.compactMap { doc -> Rental? in
                        do {
                            let rental = try doc.data(as: Rental.self)
                            return rental
                        } catch _ {

                            return nil
                        }
                    }

                    self.rentals = rentals
                }
                else {
                    print("No rentals found for user: \(currentUser.uid)")
                }
            }
    }
// pulls Ride information from firestore
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

    // Apply filters to rentals triggered by user input
    func applyFilters() {
        updatedRentals = rentals.filter { rental in
            (selectedRentalType == "All" || selectedRentalType == "Rental")
                && (selectedCarType == "All"
                    || rental.carModel.carType == selectedCarType)
                && (selectedTimeFrame == "All"
                    || isWithinTimeFrame(rental.pickupDate))
        }.sorted { first, second in
            switch selectedSort.title {
            case "Most Recent":
                return first.pickupDate > second.pickupDate
            case "Oldest":
                return first.pickupDate < second.pickupDate
            case "Alphabetical (Ascending)":
                let firstWord1 =
                    first.carModel.carName.components(separatedBy: " ").first?
                    .lowercased() ?? ""
                let firstWord2 =
                    second.carModel.carName.components(separatedBy: " ").first?
                    .lowercased() ?? ""
                return firstWord1 < firstWord2
            case "Alphabetical (Descending)":
                let firstWord1 =
                    first.carModel.carName.components(separatedBy: " ").first?
                    .lowercased() ?? ""
                let firstWord2 =
                    second.carModel.carName.components(separatedBy: " ").first?
                    .lowercased() ?? ""
                return firstWord1 > firstWord2
            case "Price (Ascending)":
                return first.totalCost < second.totalCost
            case "Price (Descending)":
                return first.totalCost > second.totalCost
            default:
                return true
            }
        }

        // Apply filters and sorting to rides
        updatedRides = rides.filter { ride in
            (selectedRentalType == "All" || selectedRentalType == "Ride")
                && (selectedCarType == "All"
                    || ride.carModel.carType == selectedCarType)
                && (selectedTimeFrame == "All"
                    || isWithinTimeFrame(ride.arrivalTime))
        }.sorted { first, second in
            switch selectedSort.title {
            case "Most Recent":
                return first.arrivalTime > second.arrivalTime
            case "Oldest":
                return first.arrivalTime < second.arrivalTime
            case "Alphabetical (Ascending)":
                let firstWord1 =
                    first.carModel.carName.components(separatedBy: " ").first
                    ?? ""
                let firstWord2 =
                    second.carModel.carName.components(separatedBy: " ").first
                    ?? ""
                return firstWord1 < firstWord2
            case "Alphabetical (Descending)":
                let firstWord1 =
                    first.carModel.carName.components(separatedBy: " ").first
                    ?? ""
                let firstWord2 =
                    second.carModel.carName.components(separatedBy: " ").first
                    ?? ""
                return firstWord1 > firstWord2
            case "Price (Ascending)":
                return first.totalCost < second.totalCost
            case "Price (Descending)":
                return first.totalCost > second.totalCost
            default:
                return true
            }
        }
// Checks if date is within a certain time frame
        func isWithinTimeFrame(_ date: Date) -> Bool {
            switch selectedTimeFrame {
            case "Today":
                return Calendar.current.isDateInToday(date)
            case "This Week":
                return Calendar.current.isDate(
                    date, equalTo: Date(), toGranularity: .weekOfYear)
            case "This Month":
                return Calendar.current.isDate(
                    date, equalTo: Date(), toGranularity: .month)
            default:
                return true  // "All" timeframe
            }
        }
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
                        } else if updatedRentals.isEmpty && updatedRides.isEmpty
                        {
                            Text("No rides or rentals found")
                                .foregroundColor(.white)
                            Spacer()
                        } else {

                            ScrollView {
                                if !updatedRentals.isEmpty {
                                    Text("Rentals")
                                        .font(.headline)
                                        .padding(.horizontal)
                                        .foregroundStyle(.white)
                                        .multilineTextAlignment(.leading)

                                    ForEach(updatedRentals) { rental in
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
                                if !updatedRides.isEmpty {
                                    Text("Rides")
                                        .font(.headline)
                                        .padding(.horizontal)
                                        .foregroundStyle(.white)
                                        .multilineTextAlignment(.leading)
                                    ForEach(updatedRides) { ride in
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
            applyFilters()
            isLoading = false
        }
        .onChange(of: isFilterActive) {
            //            fetchUserRentals()  // Fetch rentals and rides when the view appears
            //            fetchUserRides()
            applyFilters()
            isFilterActive = false
        }
        .onChange(of: rides) {
            applyFilters()
        }
        .onChange(of: rentals) {
            applyFilters()
        }
        .onChange(of: selectedSort) {
            applyFilters()
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
                selectedRentalType: $selectedRentalType,
                isFilterActive: $isFilterActive
            )
            .environment(\.colorScheme, .dark)
        }
        .sheet(isPresented: $showingSortView) {
            ActivitySortView(
                selectedSort: $selectedSort, isSortActive: $isSortActive
            )
            .environment(\.colorScheme, .dark)
        }

    }
}

#Preview {
    ActivityView()
}
