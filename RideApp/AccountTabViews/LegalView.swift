//
//  LegalView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/3/24.
//


import SwiftUI

struct LegalView: View {
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
                            
                            Text("Legal")
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
                        
                        VStack {
                           
                            VStack(spacing: 16) {
                                navRow(label: "Copyright")
                                navRow(label: "Terms & Conditions")
                                navRow(label: "Privacy Policy")
                                navRow(label: "Location Information")
                                navRow(label: "Learn More")
                                
                                
                            }
                        }
                        .padding(.top, 30)
                        
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
    LegalView()
}
