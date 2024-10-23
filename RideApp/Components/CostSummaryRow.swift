//
//  CostSummaryView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/22/24.
//


import SwiftUI

struct CostSummaryRow: View {
    var leftText: String
    var rightText: String
    var color: Color = .white // Default color if none is provided

    var body: some View {
        VStack {
            HStack {
                Text(leftText)
                    .foregroundColor(color)
                    .padding(.leading, 5)
                Spacer()
                Text("$" + rightText)
                    .foregroundColor(color)
                    .padding(.trailing, 5)
            }
            Divider()
                .background(Color.gray)
        }
        .padding(.horizontal)
    }
}
