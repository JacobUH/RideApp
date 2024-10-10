import MapKit
import SwiftUI

struct RidesView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass:
        UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass:
        UserInterfaceSizeClass?

    @State private var originAddress: String = ""
    @State private var destinationAddress: String = ""
    @State private var driveTime: String = "Next Stop?"

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
                                MapViewContainer()
                                    .edgesIgnoringSafeArea(.bottom)  // Ensure map extends below
                                    .frame(
                                        maxWidth: .infinity,
                                        maxHeight: .infinity
                                    )
                                    .padding(.vertical, 16)
                                //                                    .cornerRadius(24)

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
