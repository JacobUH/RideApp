//
//  SectionHeader.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/23/24.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .padding(.leading)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
            Spacer()
        }
    }
}
