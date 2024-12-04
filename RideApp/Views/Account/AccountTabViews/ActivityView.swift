//
//  ActivityView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/3/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ActivityView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode

    private let db = Firestore.firestore() // Firestore instance
    @State private var rentals: [Rental] = []  // Store rentals fetched from Firestore
    @State private var isLoading = true
    @State private var navigationPath = NavigationPath()
    
    func fetchUserRentals() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No authenticated user found.")
            return
        }

        db.collection("user_rentals")
            .whereField("userId", isEqualTo: currentUser.uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching rentals: \(error.localizedDescription)")
                } else {
                    if let documents = snapshot?.documents {
                        let rentals = snapshot?.documents.compactMap { doc -> Rental? in
                            do {
                                let rental = try doc.data(as: Rental.self)
                                //print("Decoded rental: \(rental)")  // Log the decoded rental
                                return rental
                            } catch {
                                //print("Error decoding rental: \(error)")  // Log any decoding errors
                                return nil
                            }
                        } ?? []

                        self.rentals = rentals
                        //print("Fetched rentals: \(self.rentals)")  // Log the rentals array
                    }
                }
                self.isLoading = false
            }
    }


    var body: some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
        
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
                        .shadow(
                          color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 10, y: 10
                        )
                        Spacer()
                        
                        if isLoading {
                            ProgressView()
                        } else if rentals.isEmpty {
                            Text("No rentals found")
                                .foregroundColor(.white)
                            Spacer()
                        } else {
                            ScrollView {
                                ForEach(rentals) { rental in
                                    Button(action: {
                                        // Append the entire rental object to the navigation path
                                        navigationPath.append(rental)
                                    }) {
                                        ActivityCard(
                                            CarName: rental.carModel.carName,
                                            imageName: rental.image,
                                            pickupDate: rental.pickupDate,
                                            dropoffDate: rental.dropoffDate,
                                            totalCost: String(format: "$%.2f", rental.totalCost)
                                        )
                                        .padding(.bottom, 10)
                                    }
                                }
                            }
                            .padding(.top, 20)

                        }
                    }
                    else if orientation.isLandscape(device: .iPhone){}
                    else {}
                }
                .navigationDestination(for: Rental.self) { rental in
                    RentalConfirmationView(
                        carModel: rental.carModel,
                        pickupDate: rental.pickupDate,
                        dropoffDate: rental.dropoffDate,
                        totalCost: rental.totalCost,
                        navigationPath: $navigationPath
                    )
                    .navigationBarBackButtonHidden(true)
                    .toolbar(.hidden, for: .tabBar)
                }
                
            }
           
        }
        .onAppear {
            fetchUserRentals()  // Fetch rentals when the view appears
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Image(systemName: "person.crop.circle.fill")
            Text("Account")
        }
        
        
    }
}

#Preview {
    ActivityView()
}
