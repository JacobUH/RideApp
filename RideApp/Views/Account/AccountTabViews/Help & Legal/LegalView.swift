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
    
    @State private var selectedLegal: Option?
    @State private var legalOptions: [Option] = [
    Option(label: "Copyright", details: """
    
    All content, including but not limited to text, images, logos, videos, audio files, graphics, and software, available through this application is the property of RideApp or its respective content providers and is protected by United States and international copyright laws. 

    You may not copy, reproduce, republish, upload, post, transmit, or distribute any content from this app without obtaining prior written consent from RideApp or the respective copyright holder. Unauthorized use of any content may result in legal consequences, including, but not limited to, termination of access to the app and legal action.

    If you believe that your copyrighted work has been infringed upon by content in the app, please contact us immediately with the necessary details.
    """),
    
    Option(label: "Terms & Conditions", details: """
    
    By accessing or using the RideApp application, you agree to comply with and be bound by these Terms and Conditions and our Privacy Policy. These terms constitute a legal agreement between you and RideApp, governing your use of the app, services, and any content available through the app.

    **Eligibility**: 
    You must be at least 18 years old and capable of entering into a legally binding agreement to use this app. If you are under 18, you may use this app only with the involvement of a parent or guardian.

    **Account Registration**: 
    To use certain features, you must create an account. You agree to provide accurate and up-to-date information and to keep your login credentials secure.

    **License Grant**:
    RideApp grants you a limited, non-transferable, and revocable license to access and use the app. This license is for personal, non-commercial use only.

    **Prohibited Conduct**:
    You agree not to engage in any illegal, abusive, or fraudulent activity while using the app. This includes, but is not limited to, hacking, data scraping, harassment, or submitting harmful content.

    **Termination**:
    RideApp reserves the right to suspend or terminate your access to the app at any time, for any reason, without notice, including for violation of these terms.

    Please review the complete Terms and Conditions for further details on usage, limitations, and obligations.
    """),
    
    Option(label: "Privacy Policy", details: """
    
    At RideApp, we are committed to protecting your privacy. This Privacy Policy outlines how we collect, use, disclose, and safeguard your personal information when you use the app.

    **Information We Collect**:
    - **Personal Information**: This may include your name, email address, phone number, and payment details when you sign up or make a reservation.
    - **Location Data**: We may collect location data to help provide location-based services, such as showing nearby cars and offering relevant promotions.
    - **Usage Data**: We collect information about how you interact with the app, including device information, app usage patterns, and crash reports.

    **How We Use Your Information**:
    - To process transactions and bookings
    - To send updates and reminders about your rentals
    - To improve the app’s functionality and user experience
    - To respond to customer support inquiries
    - To send promotional materials (with your consent)

    **How We Protect Your Data**:
    We implement industry-standard security measures, including encryption, to protect your data from unauthorized access.

    **Sharing Your Information**:
    We do not sell or rent your personal information. However, we may share your data with third-party service providers to support app functionality (such as payment processors and analytics providers), subject to strict confidentiality agreements.

    You can manage your data preferences or request to delete your account by contacting our support team. For more details, please review our full Privacy Policy.
    """),
    
    Option(label: "Location Information", details: """
    
    RideApp collects location data to provide services based on your geographic location. This includes:
    
    - **Finding nearby vehicles**: Location data helps us show available cars near your current location.
    - **Booking and pickup services**: We use location data to find the best pickup and drop-off points.
    - **Location-based promotions**: You may receive exclusive offers based on your location.
    
    **Managing Location Permissions**:
    You can control location data access through your device's settings. If you choose not to share your location, you can still use the app but may not have access to some location-based features.
    
    **Data Sharing**:
    We do not share your location data with third parties except for the purpose of providing services (such as showing nearby cars). We respect your privacy and ensure that location data is kept secure.
    """),
    
    Option(label: "Learn More", details: """
    
    RideApp provides a range of features to help you with your vehicle rentals and bookings. Here's how you can get the most out of the app:
    
    - **Browse Cars**: You can filter cars by type, size, availability, and location.
    - **Make Reservations**: Simply choose your vehicle, pick-up location, and rental dates, and confirm your booking.
    - **Track Your Ride**: Stay updated on your rental status, including pick-up and drop-off times.
    - **Earn Rewards**: With every rental, you accumulate reward points that can be redeemed for discounts or special offers.
    
    **Customer Support**:
    Our support team is available to assist with any issues or questions you may have. You can contact us through the app or visit our help center for common queries.
    
    **Updates and New Features**:
    We are constantly improving the app and introducing new features. Make sure you have the latest version of the app to enjoy all the benefits.

    For additional information, please visit our website or contact support for assistance. We're here to help!
    """)
    ]

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
                                ForEach(legalOptions) { option in
                                    navRow(label: option.label)
                                        .onTapGesture {
                                            selectedLegal = option
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
           
        })
        .sheet(item: $selectedLegal) { legal  in
            InfoDetailSheet(label: legal.label ,text: legal.details)
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
    LegalView()
}
