//
//  FilterView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/23/24.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCarType: String
    @Binding var minPrice: String
    @Binding var maxPrice: String
    
    // types of cars
    let carTypes = ["All", "Sedan", "SUV", "Truck", "Coupe"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Car Type")) {
                    Picker("Select Car Type", selection: $selectedCarType) {
                        ForEach(carTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                Section(header: Text("Price Range")) {
                    HStack {
                        TextField("Min Price", text: $minPrice)
                            .keyboardType(.decimalPad)
                        TextField("Max Price", text: $maxPrice)
                            .keyboardType(.decimalPad)
                    }
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
