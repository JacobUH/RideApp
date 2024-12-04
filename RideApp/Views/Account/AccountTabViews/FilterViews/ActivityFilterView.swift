//
//  ActivityFilterView.swift
//  RideApp
//
//  Created by Sage Turner on 12/4/24.
//

import SwiftUI

struct ActivityFilterView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCarType: String
    @Binding var selectedTimeFrame: String
    @Binding var selectedRentalType: String

    let rentalTypes: [String] = ["All", "Renal", "Ride"]
    let carTypes: [String] = ["All", "Sedan", "SUV", "Truck", "Coupe"]
    let timeFrames: [String] = ["All", "Today", "Yesterday", "Last Week", "Last Month"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Rental Type")) {
                    Picker("Select Rental Type", selection: $selectedRentalType) {
                        ForEach(rentalTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                Section(header: Text("Car Type")) {
                    Picker("Select Car Type", selection: $selectedCarType) {
                        ForEach(carTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Time Ordered")) {
                    Picker("Select Time Frame", selection: $selectedTimeFrame) {
                        ForEach(timeFrames, id: \.self) { time in
                            Text(time).tag(time)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                }

            }
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        dismiss()
                    }
                }
            }
        }
    }
}
