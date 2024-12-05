//
//  CarCard.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/22/24.
//

import SwiftUI

// used to display cars on the rentalView

struct CarCard: View {
    let imageName: String
    let CarName: String
    let dailyCost: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                Image(imageName)
                    .resizable()
                    .frame(height: 220)
                HStack {
                    Text(CarName)
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.leading, 10)
                    Spacer()
                    Text("$" + dailyCost + "/day")
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.trailing, 10)
                }
                .padding(.vertical, 10)
                
            }
        }
        .background(Color(red: 0.19, green: 0.19, blue: 0.2))
        .cornerRadius(5)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        .frame(maxWidth: .infinity, minHeight: 270)
        .padding([.leading, .trailing], 15)
    }
}
