//
//  ProfileRow.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/23/24.
//

import SwiftUI

struct ProfileRow: View {
    var label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
                .background(Color.gray)

            HStack {
                Text(label)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.leading, 15)

                Spacer()

                TextField("", text: $text)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.gray)
                    .padding(.trailing, 15)
            }
        }
    }
}
