//
//  RewardsView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/3/24.
//


import SwiftUI

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .padding(.leading)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
            Spacer()
        }
    }
}

struct CardDetails: View {
    let imageName: String
    let title: String
    let description: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 5) {
                Image(imageName)
                    .resizable()
                
                Text(title)
                    .padding(.horizontal, 10)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "#4FA0FF")) // Custom blue color
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(description)
                    .padding([.horizontal, .bottom], 10)
                    .font(.system(size: 13))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .background(Color(red: 0.19, green: 0.19, blue: 0.2))
        .cornerRadius(5)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        .frame(height: 280)
        .padding([.leading, .trailing], 15)
    }
}

struct RewardsView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
        
        NavigationView(content: {
            ZStack {
                Color(hex: "1C1C1E")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if orientation.isPortrait(device: .iPhone) {
                        ZStack {
                            HStack {
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Image(systemName: "chevron.backward")
                                        .foregroundStyle(Color(hex: "999999"))
                                        .padding(.leading)
                                }
                                Spacer()
                            }
                            
                            Text("Rewards")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.clear)
                        .background(Color(hex: "1C1C1E"))
                        .shadow(
                          color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 10, y: 10
                        )
                        
                        // content
                        VStack {
                            ScrollView {
                                // Membership Perks Section
                                SectionHeader(title: "Membership Perks")
                                
                                CardDetails(imageName: "rideMembership",
                                            title: "Complimentary Ride VIP Membership",
                                            description: "Get a free month of Ride VIP membership with any rental over $300. Enjoy perks like priority booking and exclusive discounts.")
                                
                                CardDetails(imageName: "hiltonPoints",
                                            title: "Collect Hilton Honors Points",
                                            description: "Earn 5 Hilton Honors points for every rental day. Redeem for free stays and upgrades.")
                                
                                // Cashback and Discounts Section
                                SectionHeader(title: "Cashback and Discounts")
                                    .padding(.top, 20)
                                
                                CardDetails(imageName: "applePay",
                                            title: "5% Cashback with Apple Pay",
                                            description: "Get 5% cashback on all Ride rentals when you pay with Apple Pay")
                                
                                CardDetails(imageName: "skylineImage",
                                            title: "$20 Off Your First Ride",
                                            description: "Sign up today and get $20 off your first rental with code FIRST20.")
                            }
                        }
                        .padding(.top, 10)

                        
                        Spacer()
                    }
                    else if orientation.isLandscape(device: .iPhone){}
                    else {}
                }
                
            }
           
        })
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Image(systemName: "person.crop.circle.fill")
            Text("Account")
        }
        
        
    }
}

#Preview {
    RewardsView()
}
