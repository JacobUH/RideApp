//
//  HelpView.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/3/24.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @Environment(\.presentationMode) var presentationMode
    
    @State private var navigationPath = NavigationPath()
    
    @State private var selectedHelp: Option?
    @State private var helpOptions: [Option] = [
    Option(label: "FAQs", details: """
    
    Welcome to the Frequently Asked Questions (FAQs) section!
    
    Here you'll find answers to some of the most common queries we receive. If you can’t find what you're looking for, don’t hesitate to contact our support team for further assistance.

    **How do I rent a car?**
    To rent a car, simply browse our available vehicles, select your desired car, pick-up location, and rental dates, and complete your booking!

    **Can I cancel my reservation?**
    Yes, you can cancel your booking up to 24 hours before the scheduled pick-up time for a full refund.

    **What types of cars are available?**
    We offer a wide range of vehicles including compact, SUVs, luxury, and electric cars. Check out our app for more details!

    **How do I update my personal information?**
    To update your profile, go to the 'Account' section in the app, where you can edit your contact details, payment information, and more.

    For additional questions, feel free to reach out to our support team!
    """),
    Option(label: "Contact Support", details: """
    
    If you need assistance with your booking, or have any questions, our support team is here to help!

    **How to contact us:**

    **Email**: You can email us at support@rideapp.com. We aim to respond within 24 hours.
    
    **Phone**: Reach us directly at (832) 123-4567 during our business hours, Monday to Friday, 9 AM - 5 PM.

    Whether you're facing issues with your rental or need help with the app, we're happy to assist you.
    """),
    Option(label: "App Guide", details: """
    
    Welcome to the RideApp guide! This will help you navigate through the app and make the most out of your rental experience.

    **Getting Started:**
    **Sign In/Sign Up**: To use our app, you need to create an account. Sign up with your email address or log in using your existing credentials.
    
    **Browse Cars**: Once signed in, browse through our car listings by location, car type, and rental dates. You can filter cars by price, size, and availability.
    
    **Book a Rental**: After selecting your car, simply enter your pick-up and drop-off dates, and provide payment details to complete your booking.

    **Managing Your Reservations:**
    **My Rentals**: View your current, upcoming, and past reservations under the 'My Rentals' section. You can cancel or modify bookings here.
    
    **Account Settings**: Edit your personal information, payment methods, and preferences in the 'Account' section of the app.

    **Additional Features:**
    **Notifications**: Get timely alerts for your rental, including pick-up reminders and rental extensions.
    **Rewards Program**: Earn points for every rental and unlock exclusive discounts and promotions.

    For more information, visit our support page or contact us directly if you need further assistance.
    """)
    ]
    
    var body: some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
        
        NavigationStack(path: $navigationPath){
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
                                ForEach(helpOptions) { option in
                                    navRow(label: option.label)
                                        .onTapGesture {
                                            selectedHelp = option
                                        }
                                }
                            }
                        }
                        .padding(.top, 30)
                        
                        Spacer()
                    }
                    else if orientation.isLandscape(device: .iPhone){}
                    else {}
                }
                
            }
           
        }
        .sheet(item: $selectedHelp) { help  in
            InfoDetailSheet(label: help.label ,text: help.details)
                .environment(\.colorScheme, .dark)
        }
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


