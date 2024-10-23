//
//  HomeView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/1/24.
//

import SwiftUI

struct HomeView: View {    
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?

    var body: some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
        
        NavigationView(content: {
            ZStack {
                Color(hex: "1C1C1E")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if orientation.isPortrait(device: .iPhone) {
                        ZStack {
                            Image("homeBanner")
                                .resizable()
                                .scaledToFit()
                            VStack (alignment: .leading ,spacing: 0){
                                Text("Ride Into")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                                Text("Tomorrow")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(Color(hex: "4FA0FF"))
                            }
                            .offset(x:-80, y:0)
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                          Text("Popular Rentals")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            HStack (spacing: 0) {
                                Text("Or check out all our")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.white)
                                Text(" rentals here")
                                      .font(.system(size: 12, weight: .regular))
                                      .foregroundColor(Color(hex: "4FA0FF"))
                            }
                          
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 1).padding(.leading)

                        
                        ScrollView (.horizontal) {
                            HStack (spacing: 15) {
                                VStack {
                                    Image("herreraRiptide")
                                    ZStack {
                                      Text("Herrera Riptide - Terrier")
                                        .font(Font.custom("SF Pro", size: 12))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                      Text("$74/day")
                                        .font(Font.custom("SF Pro", size: 12))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)

                                    }
                                    .padding(4)
                                }
                                VStack {
                                    Image("archerQuartz")
                                    ZStack {
                                      Text("Archer Quartz")
                                        .font(Font.custom("SF Pro", size: 12))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                      Text("$45/day")
                                        .font(Font.custom("SF Pro", size: 12))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                    .padding(.vertical, 2)
                                }
                                VStack {
                                    Image("chevillionThrax")
                                    ZStack {
                                      Text("Chevillion Thrax")
                                        .font(Font.custom("SF Pro", size: 12))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                      Text("$37/day")
                                        .font(Font.custom("SF Pro", size: 12))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)

                                    }
                                    .padding(.vertical, 2)
                                }
                            }
                            
                            
                        }
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 3) {
                          Text("Nearby Rides")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            HStack (spacing: 0) {
                                Text("Or find a driver to get you a")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.white)
                                Text(" ride here")
                                      .font(.system(size: 12, weight: .regular))
                                      .foregroundColor(Color(hex: "4FA0FF"))
                            }
                          
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 10).padding(.leading)
                        
                        ScrollView (.horizontal) {
                            HStack (spacing: 15) {
                                VStack {
                                    Image("cortesV5000")
                                    ZStack {
                                      Text("Cortes V5000 Valor")
                                        .font(Font.custom("SF Pro", size: 12))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                      Text("9:49PM • 8 min")
                                        .font(Font.custom("SF Pro", size: 12))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)

                                    }
                                    .padding(4)
                                }
                                VStack {
                                    Image("archerECL")
                                    ZStack {
                                      Text("Archer Quartz EC-L")
                                        .font(Font.custom("SF Pro", size: 12))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                      Text("9:53PM • 12 min")
                                        .font(Font.custom("SF Pro", size: 12))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                    .padding(.vertical, 2)
                                }
                                VStack {
                                    Image("quadraSportR7")
                                    ZStack {
                                      Text("Quadra Sport R-7")
                                        .font(Font.custom("SF Pro", size: 12))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                      Text("9:46PM • 5 min")
                                        .font(Font.custom("SF Pro", size: 12))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)

                                    }
                                    .padding(.vertical, 2)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    else if orientation.isLandscape(device: .iPhone){}
                    else {}
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("RIDE")
                            .font(.system(size: 24, weight: .black))
                            .foregroundStyle(.white)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
           
        })
        
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Image(systemName: "house.fill")
            Text("Home")
        }
        
        
        
    }
}

#Preview {
    HomeView()
}
