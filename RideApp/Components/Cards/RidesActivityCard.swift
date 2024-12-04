//
//  RidesActivityCard.swift
//  RideApp
//
//  Created by Sage Turner on 12/4/24.
//

import SwiftUI

struct RidesActivityCard: View {
    let CarData: Ride
    
    var body: some View {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"  // Month (full name) and day, e.g., "September 25"
        
        // Convert pickupDate and dropoffDate to string within the body
        let arrivalTime = CarData.arrivalTime
        
        return ZStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    VStack (alignment: .leading){
                        Text("Ride Reservation")
                            .lineLimit(1)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color(hex: "4FA0FF"))
                            .padding(.leading, 10)
                        Text(arrivalTime.formatted(.dateTime.year().month().day().hour().minute()))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.leading, 10)

                        Text(CarData.carModel.carName)
                            .lineLimit(1)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.leading, 10)
                        Spacer()
                        Text(CarData.originAddress)
                            .lineLimit(1)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.leading, 10)
                        Text(CarData.destinationAddress)
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
