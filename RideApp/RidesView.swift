import CoreLocation
import MapKit
import SwiftUI

struct RidesView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass:
        UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass:
        UserInterfaceSizeClass?

    @State public var originAddress: String = ""
    @State public var destinationAddress: String = ""
    @State public var driveTime: String = "Next Stop?"

    @State private var isDrawerVisible: Bool = false  // State to control the drawer visibility

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 29.7295, longitude: -95.3443),
        span: MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09)  // Zoom level
    )
     

    var body: some View {
        let orientation = DeviceHelper(
            widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)

        NavigationView {
            ZStack {
                Color(hex: "1C1C1E")
                    .edgesIgnoringSafeArea(.all)  // Background color for the entire view

                VStack {
                    if orientation.isPortrait(device: .iPhone) {
                        VStack(spacing: 0) {
                            // Title "RIDE"
                            Text("RIDE")
                                .font(.system(size: 24, weight: .black))
                                .foregroundStyle(.white)
                                .padding(.vertical, 4)

                            // Map and search bar overlay
                            ZStack(alignment: .top) {
                                // Map takes up all available space

                                Map(coordinateRegion: $region)
                                    .frame(maxWidth: .infinity, maxHeight: 700)
                                    .edgesIgnoringSafeArea(.all)
                                    .padding(.vertical, 16)

                                // Search bar overlay
                                TextField(
                                    "", text: $originAddress,
                                    prompt: Text(
                                        "\(Image(systemName: "magnifyingglass")) Next Stop?"
                                    )
                                    .foregroundColor(.white)
                                )
                                .padding(20)
                                .background(Color(hex: "303033").opacity(0.8))  // Slightly transparent background
                                .cornerRadius(24)
                                .padding(.horizontal, 32)  // Horizontal padding for the search bar
                                .padding(.top, 25)  // Space between the map top and search bar
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .autocorrectionDisabled()
                            }
                        }
                        .frame(maxHeight: .infinity)  // Ensure the VStack fills the entire screen
                    } else if orientation.isLandscape(device: .iPhone) {
                        // Handle landscape orientation if needed
                    } else {
                        // Handle other device types or orientations
                    }
                }

                // Drawer Popup at the bottom of the screen
                VStack {
                    Spacer()  // Push the drawer to the bottom
                    if isDrawerVisible {
                        VStack {
                            // Drawer handle
                            Capsule()
                                .frame(width: 40, height: 6)
                                .foregroundColor(.gray)
                                .padding(.top, 8)

                            // Drawer content
                            VStack {
                                HStack {
                                    VStack {
                                        Text("From")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                            .padding()
                                        Text("\(originAddress)")
                                            .font(.headline).foregroundStyle(.white)
                                    }
                                    VStack {
                                        Text("To")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                            .padding()
                                        Text("\(destinationAddress)")
                                            .font(.headline).foregroundStyle(.white)
                                    }
                                }
                            }

                            // Close button
                            Button(action: {
                                withAnimation {
                                    isDrawerVisible = false
                                }
                            }) {
                                Text("Close Drawer")
                                    .foregroundColor(.blue)
                            }
                            .padding(.bottom, 20)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "1C1C1E"))  // Updated background color
                        .cornerRadius(20)
                            .transition(.move(edge: .bottom))  // Slide in from the bottom
                            .animation(.easeInOut, value: isDrawerVisible)
                    }
                }
            }
            .onTapGesture {
                withAnimation {
                    isDrawerVisible.toggle()  // Toggle drawer visibility when tapping the screen
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Image(systemName: "mappin.and.ellipse")
            Text("Rides")
        }
    }
}

// Custom MapView container
struct MapViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update the map view if needed
    }
}


#Preview {
    RidesView()
}
