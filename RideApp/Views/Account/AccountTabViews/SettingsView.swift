//
//  SettingsView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/3/24.
//


import SwiftUI

struct SettingsView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showAlert = false
    @State private var logoutSuccess = false


    var body: some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
        
        NavigationStack{
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
                            
                            Text("Settings")
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
                        
                        VStack{
                            SectionHeader(title: "App Settings")
                            ToggleRow(label: "Dark Mode")
                            ToggleRow(label: "Language")
                            
                            SectionHeader(title: "Notifications")
                            .padding(.top, 10)
                            ToggleRow(label: "Reservation Reminders")
                            ToggleRow(label: "Reservation Updates")
                            ToggleRow(label: "Refund Notices")
                            ToggleRow(label: "Pickup/Dropoff Reminders")
                            ToggleRow(label: "Exclusive Offers")
                            
                            Button (action: {
                                showAlert = true
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Logout")
                                        .foregroundStyle(.red)
                                        .padding(.all)
                                    Spacer()
                                }
                            }
                            .contentShape(Rectangle())
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Logout of your account?"),
                                      primaryButton: .destructive(Text("Logout"), action: {
                                        logoutSuccess = true
                                }),
                                      secondaryButton: .cancel(Text("Cancel"))
                                )
                            }
                            
                            
                        }
                        .padding(.top, 10)
                        
                        Spacer()
                    }
                    else if orientation.isLandscape(device: .iPhone){}
                    else {}
                }
                
            }
            .navigationDestination(isPresented: $logoutSuccess) {
                LandingView()
                    .toolbar(.hidden, for: .tabBar)
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Image(systemName: "person.crop.circle.fill")
            Text("Account")
        }
    }
}

#Preview {
    SettingsView()
}
