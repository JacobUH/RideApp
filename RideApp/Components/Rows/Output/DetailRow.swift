//
//  DetailRow.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/22/24.
//

import SwiftUI

struct DetailRow: View {
    var label, desc: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(label)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .alignmentGuide(.firstTextBaseline) { d in d[.top] }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)

                Text(desc)
                    .font(.system(size: 13))
                    .foregroundColor(Color(.white))
                    .alignmentGuide(.firstTextBaseline) { d in d[.top] } // Align desc to the top as well
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                Spacer()
            }
            .padding(.vertical, 3)
            Divider()
                .background(Color.gray)
        }
    }
}
