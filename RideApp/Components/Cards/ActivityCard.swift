//
//  ActivityCard.swift
//  RideApp
//
//  Created by Jacob Rangel on 11/18/24.
//

import SwiftUI

struct ActivityCard: View {
    let CarName: String
    let imageName: String
    let pickupDate: Date
    let dropoffDate: Date
    let totalCost: String
    
    var body: some View {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"  // Month (full name) and day, e.g., "September 25"
        
        // Convert pickupDate and dropoffDate to string within the body
        let pickupDateString = dateFormatter.string(from: pickupDate)
        let dropoffDateString = dateFormatter.string(from: dropoffDate)
        
        return ZStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    VStack (alignment: .leading){
                        Text("Rental Reservation")
                            .lineLimit(1)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color(hex: "4FA0FF"))
                            .padding(.leading, 10)
                        Text(pickupDateString + " - " + dropoffDateString)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.leading, 10)

                        Spacer()
                        Text(CarName)
                            .lineLimit(1)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.leading, 10)
                        Text("CarExterior")
                            .lineLimit(1)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.leading, 10)
                        Spacer()
                        Text(totalCost + " ~ " + "Apple Pay")
                            .lineLimit(1)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.leading, 10)
                        
                    }
                    
                    Spacer()
                    Image(imageName)
                        .resizable()
                        .frame(width: 180, height: 113)
                        .padding(.trailing, 10)
                }
                .padding(.vertical, 10)
                
            }
        }
        .background(Color(red: 0.19, green: 0.19, blue: 0.2))
        .cornerRadius(5)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing], 15)
    }
}
