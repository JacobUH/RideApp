//
//  RidesSetRouteView.swift
//  RideApp
//
//  Created by Sage Turner on 11/19/24.
//

import SwiftUI
import UIKit

struct RidesLocationSearchView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass:
        UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass:
        UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject private var locationSearchVM: LocationSearchViewModel
    @State private var startLocationText = ""
    @Binding var navigationPath: NavigationPath
    @Binding var destinationAddress: String

    var body: some View {
        let orientation = DeviceHelper(
            widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)

        ZStack {
            Color(hex: "1C1C1E")
                .edgesIgnoringSafeArea(.all)
            if orientation.isPortrait(device: .iPhone) {
                VStack {
                    HStack {
                        Spacer()
                        Text("Where to?")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        Color(hex: "303033")
                            .frame(width: 40, height: 35)
                    }

                    HStack {
                        VStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 8, height: 8)
                                .padding(.horizontal)

                            Rectangle()
                                .fill(.gray)
                                .frame(width: 1, height: 22)
                                .padding(.horizontal)

                            Rectangle()
                                .fill(.white)
                                .frame(width: 8, height: 8)
                                .padding(.horizontal)
                        }
                        VStack {
                            TextField(
                                "Current location", text: $startLocationText
                            )
                            .frame(height: 32)
                            .foregroundStyle(.white)
                            .padding(
                                EdgeInsets(
                                    top: 0, leading: 6, bottom: 0, trailing: 6)
                            )
                            .cornerRadius(5)
                            .background(Color(.systemGray6))
                            .padding(.trailing)

                            TextField(
                                "Destination location",
                                text: $locationSearchVM.queryFragment
                            )
                            .frame(height: 32)
                            .foregroundStyle(.white)
                            .padding(
                                EdgeInsets(
                                    top: 0, leading: 6, bottom: 0, trailing: 6)
                            )
                            .cornerRadius(5)
                            .background(Color(.systemGray6))
                            .padding(.trailing)
                        }
                    }
                    .padding(.bottom, 12)
                    Divider()
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(locationSearchVM.results, id: \.self) {
                                result in
                                LocationSearchResultCell(
                                    title: result.title,
                                    subtitle: result.subtitle
                                )
                                .onTapGesture {
                                    destinationAddress = result.title
                                    locationSearchVM.selectLocation(result)
                                    locationSearchVM.showSelectedLocation
                                        .toggle()
                                    presentationMode.wrappedValue.dismiss()
                                }
                                .padding(.vertical, 5)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(Color(hex: "999999"))
                        .padding(.leading)
                }
            }

            ToolbarItem(placement: .principal) {
                Text("RIDE")
                    .font(.system(size: 24, weight: .black))
                    .foregroundStyle(Color(.white))
            }
        }
    }
}
