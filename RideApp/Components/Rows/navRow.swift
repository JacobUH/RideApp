//
//  navRow.swift
//  RideApp
//
//  Created by Jacob Rangel on 11/28/24.
//

import SwiftUI

struct navRow: View {
    var label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(label)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.leading, 15)

                Spacer()

                Image(systemName: "chevron.forward")
                    .font(.system(size: 12))
                    .foregroundStyle(Color(hex: "999999"))
                    .padding(.trailing)
            }
            .contentShape(Rectangle()) // Ensures the entire row is tappable

            Divider()
                .background(Color.gray)
        }
    }
}
