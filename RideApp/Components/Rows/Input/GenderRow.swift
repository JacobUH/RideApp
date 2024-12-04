//
//  GenderRow.swift
//  RideApp
//
//  Created by Jacob Rangel on 11/19/24.
//

import SwiftUI

struct GenderRow: View {
    
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
                .background(Color.gray)

            HStack {
                Text("Gender")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.leading, 15)

                Spacer()

                Picker("Select Gender", selection: $text) {
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                    Text("Other").tag("Other")
                    Text("Prefer Not to Say").tag("Prefer Not to Say")
                }
                .tint(Color(hex: "#4FA0FF"))
            }
        }
    }
}
