//
//  topBarView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/22/24.
//

import SwiftUI

struct topBarView: View {
    var body: some View {
        HStack (spacing: 1) {
            Spacer()
        }
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity)
        .foregroundColor(.clear)
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .shadow(
          color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 10, y: 10
        )
    }
}
