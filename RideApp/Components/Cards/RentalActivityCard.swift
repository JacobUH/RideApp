//
//  RentalActivityCard.swift
//  RideApp
//
//  Created by Sage Turner on 12/4/24.
//

import SwiftUI

// Card for displaying rentals on ActivityView

struct RentalActivityCard: View {
    let CarData: Rental
    
    var body: some View {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"  // Month (full name) and day, e.g., "September 25"
        
        // Convert pickupDate and dropoffDate to string within the body
        let pickupDateString = dateFormatter.string(from: CarData.pickupDate)
        let dropoffDateString = dateFormatter.string(from: CarData.dropoffDate)
        
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
                        Text(CarData.carModel.carName)
                            .lineLimit(1)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.leading, 10)
                        Text(CarData.carModel.exterior)
                            .lineLimit(1)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.leading, 10)
                        Spacer()
                        Text("$\(String(format: "%.2f", CarData.totalCost)) ~ \(CarData.selectedCard.cardType)")
                            .lineLimit(1)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.leading, 10)
                    }
                    
                    Spacer()
                    Image(CarData.carModel.images[0])
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
