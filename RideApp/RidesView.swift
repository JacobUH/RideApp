//
//  RidesView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/1/24.
//

import MapKit
import SwiftUI

struct RidesView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass:
        UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass:
        UserInterfaceSizeClass?

    @State private var fromAddress: String = ""
    @State private var destinationAddress: String = ""
    @State private var driveTime: String =
        "Next Stop?"

    var body: some View {
        let orientation = DeviceHelper(
            widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)

        NavigationView(content: {
            ZStack {
                Color(hex: "1C1C1E")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if orientation.isPortrait(device: .iPhone) {
                        Text("RIDE")
                            .font(.system(size: 24, weight: .black))
                            .foregroundStyle(.white)
                            .padding(.vertical, 4)
                        Spacer()

                        VStack(alignment: .leading) {
                            TextField(
                                "", text: $fromAddress,
                                prompt: Text(
                                    "\(Image(systemName: "magnifyingglass")) Next Stop?"
                                )
                                .foregroundColor(.white)
                            )
                            .padding(.vertical, 20)
                            .background(Color(hex: "303033"))
                            .cornerRadius(24)
                            .padding(.horizontal, 16)
                            .textFieldStyle(.plain)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .autocorrectionDisabled()
                            Spacer()
                        }

                    } else if orientation.isLandscape(device: .iPhone) {
                    } else {
                    }

                }

            }
        })
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Image(systemName: "mappin.and.ellipse")
            Text("Rides")
        }

    }
}

#Preview {
    RidesView()
}
