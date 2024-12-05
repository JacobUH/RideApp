//
//  SortView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/23/24.
//

import SwiftUI

struct SortOption: Identifiable, Equatable {
    let id = UUID()
    let title: String
}

struct SortView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedSort: SortOption?
    
    // all of the sort options
    let sortOptions: [SortOption] = [
        SortOption(title: "Best Match"),
        SortOption(title: "Alphabetical (Ascending)"),
        SortOption(title: "Alphabetical (Descending)"),
        SortOption(title: "Lowest Price"),
        SortOption(title: "Highest Price"),
        SortOption(title: "Lowest Horsepower"),
        SortOption(title: "Highest Horsepower"),
        SortOption(title: "Lowest Mileage"),
        SortOption(title: "Highest Mileage")
    ]

    var body: some View {
        NavigationView {
            List(sortOptions) { option in
                Button(action: {
                    selectedSort = option
                    dismiss()
                }) {
                    HStack {
                        Text(option.title)
                            .foregroundStyle(.white)
                        Spacer()
                        if selectedSort?.title == option.title {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 20, height: 20)
                        } else {
                            Circle()
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }
            .listRowSpacing(10)
            .navigationTitle("Sort")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .background(Color.black.opacity(0.8))
    }
}
