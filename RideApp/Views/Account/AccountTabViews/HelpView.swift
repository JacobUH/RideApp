//
//  HelpView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/3/24.
//


import SwiftUI

struct navRow: View {
    var label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button(action: {
                // your action here for the whole row
            }) {
                HStack {
                    Text(label)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.leading, 15)

                    Spacer()

                    Image(systemName: "chevron.forward")
                        .font(.system(size: 12))
                        .foregroundStyle(Color(hex: "999999"))
                        .padding(.trailing)
                }
                .contentShape(Rectangle()) // Ensures the entire HStack is tappable
            }

            Divider()
                .background(Color.gray)
        }
    }

}

struct HelpView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode
    
    @State private var firstName = "Jacob"
    @State private var lastName = "Rangel"
    @State private var email = "jacobrangel0628@gmail.com"
    @State private var phone = "(832) 123 4567"
    @State private var gender = "Male"

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
                            
                            Text("Help")
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
                                navRow(label: "FAQs")
                                navRow(label: "Contact Support")
                                navRow(label: "App Guide")
                                navRow(label: "Report An Issue")
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
    HelpView()
}
