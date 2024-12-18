//
//  CostSummaryRow 2.swift
//  RideApp
//
//  Created by Jacob Rangel on 11/19/24.
//


import SwiftUI

struct CardCheckout: View {
    let cardType: String
    let cardNumber: String
    let expDate: String
    let securityPin: String

    var body: some View {
        HStack {
            if !cardType.isEmpty {
                Image(cardType)
                    .frame(width: 50)
                    .padding(.leading)
            }
            Text((!cardType.isEmpty && !cardNumber.isEmpty) ?
                 (cardType != "Apple Pay" ? "\(cardType)   ****\(cardNumber.suffix(4))" : cardType) :
                 "No Card Selected")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.leading, cardType.isEmpty ? 25 : 0)
            Spacer()
            Image(systemName: "chevron.forward")
                .foregroundColor(Color.gray)
                .padding(.trailing, 25)
        }
        .padding(.bottom, 20)
    }
}


struct CardRow: View {
    let cardType: String
    let cardNumber: String
    let expDate: String
    let securityPin: String

    var body: some View {
        VStack {
            HStack {
                Image(cardType)
                    .frame(width: 50)
                    .padding(.leading)
                Text(cardType)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
//                Image(systemName: "chevron.forward")
//                    .foregroundColor(Color.gray)
            }
            .padding(.vertical, 5)
            Divider()
                .background(Color.gray)
        }
        .padding(.horizontal)
    }
}

struct AddRow: View {
    let label: String
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "plus")
                    .frame(width: 50)
                    .foregroundColor(.white)
                    .padding(.leading)
                Text(label)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.vertical, 5)
            Divider()
                .background(Color.gray)
        }
        .padding(.horizontal)
    }
}
