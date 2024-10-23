import CoreLocation
import MapKit
import SwiftUI

struct SearchResult: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
}

struct RidesView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?

    @StateObject private var locationManager = LocationManager()
    @State private var searchCompleter = MKLocalSearchCompleter()
    @State private var searchResults = [SearchResult]()

    @State public var destinationAddress: String = "65 Park Ln"
    @State public var originAddress: String = "13418 Misty Orchard Ln"
    @State public var driveTime: String = "Next Stop?"

    @State private var isDrawerVisible: Bool = false
    @State private var drawerOffset: CGFloat = 0  // Start with drawer hidden
    @State private var drawerHeight: CGFloat = 0  // Will be set dynamically

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 29.7295, longitude: -95.3443),
        span: MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09)
    )

    @State private var route: MKRoute?  // To store the calculated route

    var body: some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)

        NavigationView {
            ZStack {
                Color(hex: "1C1C1E")
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    if orientation.isPortrait(device: .iPhone) {
                        VStack(spacing: 0) {
                            Text("RIDE")
                                .font(.system(size: 24, weight: .black))
                                .foregroundStyle(.white)
                                .padding(.vertical, 4)

                            ZStack(alignment: .top) {
                                // Use RouteMapView for displaying the map with routes
                                RouteMapView(region: $region, route: $route)
                                    .frame(maxWidth: .infinity, maxHeight: 700)
                                    .edgesIgnoringSafeArea(.all)
                                    .padding(.vertical, 16)

                                VStack {
                                    TextField(
                                        "",
                                        text: $destinationAddress,
                                        prompt: Text("\(Image(systemName: "magnifyingglass")) Where To?")
                                            .foregroundStyle(.white)
                                    )
                                    .padding(20)
                                    .background(Color(hex: "303033").opacity(0.8))
                                    .cornerRadius(24)
                                    .padding(.horizontal, 32)
                                    .padding(.top, 10)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .autocorrectionDisabled()
                                    .onChange(of: destinationAddress) { newValue in
                                        searchCompleter.queryFragment = newValue
                                        checkDrawerVisibility()
                                    }
                                }
                                .padding(.top, 15)
                            }
                        }
                        .frame(maxHeight: .infinity)
                    }
                }

                // Search Results List
                if !searchResults.isEmpty {
                    List(searchResults) { result in
                        VStack(alignment: .leading) {
                            Text(result.title)
                                .font(.headline)
                            Text(result.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .onTapGesture {
                            destinationAddress = result.title
                            searchResults.removeAll()
                            calculateRouteToDestination()
                        }
                    }
                    .frame(height: 150)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 32)
                }

                // Background overlay when drawer is visible
                if isDrawerVisible {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            hideDrawer()
                        }
                }

                // Bottom Drawer with Ride Info
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        VStack {
                            // Drawer handle
                            Capsule()
                                .frame(width: 40, height: 6)
                                .foregroundColor(.gray)
                                .padding(.top, 8)

                            // Drawer content
                            VStack {
                                HStack(spacing: 40) {
                                    VStack {
                                        Text("From")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                            .padding()
                                        Text("\(originAddress.isEmpty ? "Not set" : originAddress)")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                    }
                                    VStack {
                                        Text("To")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                            .padding()
                                        Text("\(destinationAddress.isEmpty ? "Not set" : destinationAddress)")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                    }
                                }

                                Text("Estimated Time: \(driveTime)")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .padding(.top, 8)
                            }
                            .padding(.bottom, geometry.safeAreaInsets.bottom) // Handle safe area
                        }
                        .background(Color(hex: "1C1C1E"))
                        .cornerRadius(20)
                        .offset(y: drawerOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newOffset = value.translation.height
                                    if newOffset > 0 {
                                        drawerOffset = newOffset
                                    }
                                }
                                .onEnded { value in
                                    if value.translation.height > drawerHeight / 2 {
                                        hideDrawer()
                                    } else {
                                        showDrawer()
                                    }
                                }
                        )
                        .onAppear {
                            // Capture the drawer's height
                            drawerHeight = geometry.size.height
                            // Initially hide the drawer
                            drawerOffset = drawerHeight
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                }
            }
            .onAppear {
                searchCompleter.delegate = SearchCompleterDelegate(searchResults: $searchResults)

                // Fetch the user's current location
                region = MKCoordinateRegion(
                    center: locationManager.userLocation ?? CLLocationCoordinate2D(latitude: 29.7295, longitude: -95.3443),
                    span: MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09)
                )
                originAddress = locationManager.address
                print("Origin Address: \(originAddress)")
                print("Destination Address: \(destinationAddress)")

                checkDrawerVisibility() // Ensure drawer is updated on load if addresses are set
            }
            .onChange(of: originAddress) { _ in
                checkDrawerVisibility()
            }
            .onChange(of: destinationAddress) { _ in
                checkDrawerVisibility()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Image(systemName: "mappin.and.ellipse")
            Text("Rides")
        }
    }

    func showDrawer() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isDrawerVisible = true
            drawerOffset = 0
        }
    }

    func checkDrawerVisibility() {
        if !originAddress.isEmpty && !destinationAddress.isEmpty {
            // Both addresses are filled, show the drawer
            showDrawer()
        } else if !originAddress.isEmpty || !destinationAddress.isEmpty {
            // At least one address is filled, keep the drawer hidden but allow it to be reopened
            if !isDrawerVisible {
                drawerOffset = drawerHeight * 0.8 // Allow partial visibility so it's draggable
            }
        } else {
            hideDrawer()
        }
    }

    func hideDrawer() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isDrawerVisible = false
            drawerOffset = drawerHeight * 0.95 // Keep a small portion visible for dragging
        }
    }

    // Function to calculate route to destination
    func calculateRouteToDestination() {
        guard let userLocation = locationManager.userLocation else { return }

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))

        // Geocode destination to get coordinates
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(destinationAddress) { placemarks, error in
            guard let placemark = placemarks?.first, let destinationLocation = placemark.location else { return }

            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationLocation.coordinate))
            request.transportType = .automobile

            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                if let route = response?.routes.first {
                    self.route = route // Store the route to draw on the map
                    driveTime = "\(Int(route.expectedTravelTime / 60)) min"
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showDrawer()
                    }
                }
            }
        }
    }
}

class SearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
    @Binding var searchResults: [SearchResult]

    init(searchResults: Binding<[SearchResult]>) {
        self._searchResults = searchResults
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResults = completer.results.map {
            SearchResult(title: $0.title, subtitle: $0.subtitle)
        }
    }
}

#Preview {
    RidesView()
}
