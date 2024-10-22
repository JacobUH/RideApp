import CoreLocation
import MapKit
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var address: String = ""

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(
        _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            userLocation = location.coordinate
            reverseGeocode(location: location)
        }
    }

    func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first {
                self.address = [
                    placemark.name,
                    placemark.locality,
                    placemark.administrativeArea,
                    placemark.country,
                ]
                .compactMap { $0 }
                .joined(separator: ", ")
            }
        }
    }
}

struct SearchResult: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
}

struct RidesView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass:
        UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass:
        UserInterfaceSizeClass?

    @StateObject private var locationManager = LocationManager()
    @State private var searchCompleter = MKLocalSearchCompleter()
    @State private var searchResults = [SearchResult]()

    @State public var originAddress: String = ""
    @State public var destinationAddress: String = ""
    @State public var driveTime: String = "Next Stop?"

    @State private var isDrawerVisible: Bool = false  // State to control the drawer visibility
    @State private var drawerOffset: CGFloat =
        UIScreen.main.bounds.height * 0.4  // Initial offset for the drawer

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

                                VStack {
                                    // Destination TextField with auto-complete
                                    TextField(
                                        "", text: $destinationAddress,
                                        prompt: Text(
                                            "\(Image(systemName: "magnifyingglass")) Where To?"
                                        ).foregroundStyle(.white)
                                    )
                                    .padding(20)
                                    .background(
                                        Color(hex: "303033").opacity(0.8)
                                    )  // Slightly transparent background
                                    .cornerRadius(24)
                                    .padding(.horizontal, 32)
                                    .padding(.top, 10)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .autocorrectionDisabled()
                                    .onChange(of: destinationAddress) {
                                        newValue in
                                        searchCompleter.queryFragment = newValue
                                    }
                                }.padding(.top, 15)
                            }
                        }
                        .frame(maxHeight: .infinity)
                    }
                }

                // Auto-complete suggestions list
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
                            if originAddress.isEmpty {
                                originAddress = result.title
                            } else {
                                destinationAddress = result.title
                            }
                            searchResults.removeAll()
                        }
                    }
                    .frame(height: 150)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 32)
                }

                // Overlay to detect taps outside the drawer
                if isDrawerVisible {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isDrawerVisible = false
                                drawerOffset = UIScreen.main.bounds.height * 0.4  // Reset to initial offset
                            }
                        }
                }

                // Only show the drawer if both origin and destination are filled
                if !originAddress.isEmpty && !destinationAddress.isEmpty {
                    // Drawer Popup at the bottom of the screen
                    VStack {
                        Spacer()  // Push the drawer to the bottom
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
                                        Text("\(originAddress)")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                    }
                                    VStack {
                                        Text("To")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                            .padding()
                                        Text("\(destinationAddress)")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                    }
                                }

                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Nearby Rides")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(.white)

                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 10)
                                .padding(.leading)

                                ScrollView(.horizontal) {
                                    HStack(spacing: 15) {
                                        VStack {
                                            Image("cortesV5000")
                                            ZStack {
                                                Text("Cortes V5000 Valor")
                                                    .font(
                                                        Font.custom(
                                                            "SF Pro", size: 12)
                                                    )
                                                    .foregroundColor(.white)
                                                    .frame(
                                                        maxWidth: .infinity,
                                                        alignment: .leading)
                                                Text("9:49PM • 8 min")
                                                    .font(
                                                        Font.custom(
                                                            "SF Pro", size: 12)
                                                    )
                                                    .foregroundColor(.white)
                                                    .frame(
                                                        maxWidth: .infinity,
                                                        alignment: .trailing)
                                            }
                                            .padding(4)
                                        }
                                        VStack {
                                            Image("archerECL")
                                            ZStack {
                                                Text("Archer Quartz EC-L")
                                                    .font(
                                                        Font.custom(
                                                            "SF Pro", size: 12)
                                                    )
                                                    .foregroundColor(.white)
                                                    .frame(
                                                        maxWidth: .infinity,
                                                        alignment: .leading)
                                                Text("9:53PM • 12 min")
                                                    .font(
                                                        Font.custom(
                                                            "SF Pro", size: 12)
                                                    )
                                                    .foregroundColor(.white)
                                                    .frame(
                                                        maxWidth: .infinity,
                                                        alignment: .trailing)
                                            }
                                            .padding(.vertical, 2)
                                        }
                                        VStack {
                                            Image("quadraSportR7")
                                            ZStack {
                                                Text("Quadra Sport R-7")
                                                    .font(
                                                        Font.custom(
                                                            "SF Pro", size: 12)
                                                    )
                                                    .foregroundColor(.white)
                                                    .frame(
                                                        maxWidth: .infinity,
                                                        alignment: .leading)
                                                Text("9:46PM • 5 min")
                                                    .font(
                                                        Font.custom(
                                                            "SF Pro", size: 12)
                                                    )
                                                    .foregroundColor(.white)
                                                    .frame(
                                                        maxWidth: .infinity,
                                                        alignment: .trailing)
                                            }
                                            .padding(.vertical, 2)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "1C1C1E"))
                        .cornerRadius(20)
                        .offset(y: drawerOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    // Handle both upward and downward dragging
                                    if value.translation.height > 0 {
                                        // Dragging downward
                                        self.drawerOffset =
                                            value.translation.height + UIScreen
                                            .main.bounds.height * 0.4
                                    } else {
                                        // Dragging upward (allow reopen)
                                        self.drawerOffset = max(
                                            0,
                                            UIScreen.main.bounds.height * 0.4
                                                + value.translation.height)
                                    }
                                }
                                .onEnded { value in
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        if value.translation.height > 100 {
                                            isDrawerVisible = false
                                            drawerOffset =
                                                UIScreen.main.bounds.height
                                                * 0.4  // Close the drawer
                                        } else {
                                            isDrawerVisible = true
                                            drawerOffset = 0  // Fully open the drawer
                                        }
                                    }
                                }
                        )
                        .transition(.move(edge: .bottom))
                        .animation(
                            .easeInOut(duration: 0.5), value: isDrawerVisible)
                    }
                }
            }
            .onChange(of: originAddress) { _ in
                checkDrawerVisibility()
            }
            .onChange(of: destinationAddress) { _ in
                checkDrawerVisibility()
            }
            .onAppear {
                searchCompleter.delegate = SearchCompleterDelegate(
                    searchResults: $searchResults)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Image(systemName: "mappin.and.ellipse")
            Text("Rides")
        }
    }

    // Check if both originAddress and destinationAddress are filled
    private func checkDrawerVisibility() {
        if !originAddress.isEmpty && !destinationAddress.isEmpty {
            withAnimation(.easeInOut(duration: 0.5)) {
                isDrawerVisible = true
                drawerOffset = 0  // Open the drawer
            }
        } else {
            withAnimation(.easeInOut(duration: 0.5)) {
                isDrawerVisible = false
                drawerOffset = UIScreen.main.bounds.height * 0.4  // Close the drawer
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
