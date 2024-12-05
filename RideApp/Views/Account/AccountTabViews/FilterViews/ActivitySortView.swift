//
//  ActivitySortView.swift
//  RideApp
//
//  Created by Sage Turner on 12/4/24.
//

import SwiftUI
// Sorting sheet for ActivityView
struct ActivitySortView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedSort: SortOption
    @Binding var isSortActive: Bool
    

    let sortOptions: [SortOption] = [
        SortOption(title: "Most Recent"),
        SortOption(title: "Oldest"),
        SortOption(title: "Alphabetical (Ascending)"),
        SortOption(title: "Alphabetical (Descending)"),
        SortOption(title: "Price (Ascending)"),
        SortOption(title: "Price (Descending)"),
    ]

    var body: some View {
        NavigationView {
            List(sortOptions) { option in
                Button(action: {
                    selectedSort = option
                    isSortActive.toggle()
                    dismiss()
                }) {
                    HStack {
                        Text(option.title)
                            .foregroundStyle(.white)
                        Spacer()
                        if selectedSort.title == option.title {
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
        }        .background(Color.black.opacity(0.8))
    }
}
