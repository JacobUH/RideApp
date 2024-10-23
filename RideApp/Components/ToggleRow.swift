//
//  ToggleRow.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/22/24.
//

import SwiftUI

struct ToggleRow: View {
    var label: String
    @State private var toggleState = true

    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text(label)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.leading)
                    .layoutPriority(1)

                Spacer()
                
                Toggle(isOn: $toggleState){}
                    .tint(Color(hex: "4FA0FF"))
                    .padding(.trailing)
            }
            .padding(.vertical, 10)

            Divider()
                .background(Color.gray)
        }
    }
}
