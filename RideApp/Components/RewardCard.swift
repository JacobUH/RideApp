//
//  RewardCard.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/23/24.
//

import SwiftUI

struct RewardCard: View {
    let imageName: String
    let title: String
    let description: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 5) {
                Image(imageName)
                    .resizable()
                
                Text(title)
                    .padding(.horizontal, 10)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "#4FA0FF")) // Custom blue color
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(description)
                    .padding([.horizontal, .bottom], 10)
                    .font(.system(size: 13))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .background(Color(red: 0.19, green: 0.19, blue: 0.2))
        .cornerRadius(5)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        .frame(height: 280)
        .padding([.leading, .trailing], 15)
    }
}
