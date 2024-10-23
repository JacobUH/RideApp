//
//  ConfirmationView.swift
//  RideApp
//
//  Created by Sage Turner on 10/22/24.
//

import SwiftUI

struct SampleView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass:
        UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass:
        UserInterfaceSizeClass?
    @Binding var selectedTab: Int

    var body: some View {
        let orientation = DeviceHelper(
            widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)

        VStack {
            if orientation.isPortrait(device: .iPhone)
                || orientation.isPortrait(device: .iPhonePlusOrMax)
            {
                Text("iPhone Portrait")
            } else if orientation.isLandscape(device: .iPhone)
                || orientation.isLandscape(device: .iPhonePlusOrMax)
            {
                Text("iPhone Landscape")
            } else if orientation.isPortrait(device: .iPadFull) {
                Text("iPad")
                    .font(.largeTitle)
            } else if orientation.isLandscape(device: .iPadFull) {
                Text("iPad Landscape")
                    .font(.largeTitle)
            }
        }
        .tabItem {
            Image(systemName: "circles.hexagonpath")
            Text("Sample")
        }
        .tag(0)

    }
}

struct SampleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SampleView(selectedTab: .constant(0))
                .previewInterfaceOrientation(.portrait)
                .previewDisplayName("Portrait")

            SampleView(selectedTab: .constant(0))
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("Landscape Left")
        }
    }
}
