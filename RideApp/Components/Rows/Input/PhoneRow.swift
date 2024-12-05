//
//  PhoneRow.swift
//  RideApp
//
//  Created by Jacob Rangel on 11/19/24.
//

import SwiftUI

// formats phone number in correct format
func formatAndLimitPhoneNumber(_ number: String) -> String {
    let digits = number.filter { $0.isNumber }
    let maxDigits = 10
    let limitedDigits = String(digits.prefix(maxDigits))
    
    // Format as (XXX) XXX-XXXX
    switch limitedDigits.count {
    case 0...3:
        return limitedDigits
    case 4...6:
        let areaCode = limitedDigits.prefix(3)
        let prefix = limitedDigits.suffix(from: limitedDigits.index(limitedDigits.startIndex, offsetBy: 3))
        return "(\(areaCode)) \(prefix)"
    default:
        let areaCode = limitedDigits.prefix(3)
        let prefix = limitedDigits[limitedDigits.index(limitedDigits.startIndex, offsetBy: 3)..<limitedDigits.index(limitedDigits.startIndex, offsetBy: 6)]
        let lineNumber = limitedDigits.suffix(from: limitedDigits.index(limitedDigits.startIndex, offsetBy: 6))
        return "(\(areaCode)) \(prefix)-\(lineNumber)"
    }
}

// allows users to update/display phone number 
struct PhoneRow: View {
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
                .background(Color.gray)

            HStack {
                Text("Phone")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.leading, 15)

                Spacer()

                TextField("Enter Phone Number", text: Binding(
                    get: { text },
                    set: { newValue in
                        text = formatAndLimitPhoneNumber(newValue)
                    }
                ))
                .multilineTextAlignment(.trailing)
                .foregroundColor(.gray)
                .padding(.trailing, 15)
            }
        }
    }
}
