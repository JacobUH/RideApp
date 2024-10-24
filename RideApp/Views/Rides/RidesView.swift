import CoreLocation
import MapKit
import SwiftUI

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

    @State public var destinationAddress: String = ""
    @State public var originAddress: String = "13418 Misty Orchard Ln"
    @State public var driveTime: String = "Next Stop?"
    @State private var selectedCar: CarDetails?
    @State private var navigationPath = NavigationPath()

    @State private var cars: [CarDetails] = []

    func loadCarData() {
        if let jsonData = CarData.jsonString.data(using: .utf8) {
            do {
                let decodedData = try JSONDecoder().decode(
                    CarList.self, from: jsonData)
                cars = decodedData.cars
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }
    }

    @State private var isDrawerVisible: Bool = false
    @State private var drawerOffset: CGFloat =
        UIScreen.main.bounds.height * 0.95
    @State private var drawerHeight: CGFloat = 0

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 29.7295, longitude: -95.3443),
        span: MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09)
    )

    @State private var route: MKRoute?

    var body: some View {
        let orientation = DeviceHelper(
            widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)

        NavigationStack(path: $navigationPath) {
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
                                RouteMapView(region: $region, route: $route)
                                    .frame(maxWidth: .infinity, maxHeight: 700)
                                    .edgesIgnoringSafeArea(.all)
                                    .padding(.vertical, 16)

                                VStack {
                                    TextField(
                                        "",
                                        text: $destinationAddress,
                                        prompt: Text(
                                            "\(Image(systemName: "magnifyingglass")) Where To?"
                                        )
                                        .foregroundStyle(.white)
                                    )
                                    .padding(20)
                                    .background(
                                        Color(hex: "303033").opacity(0.8)
                                    )
                                    .cornerRadius(24)
                                    .padding(.horizontal, 32)
                                    .padding(.top, 10)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .autocorrectionDisabled()
                                    .onChange(of: destinationAddress) {
                                        newValue in
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

                if isDrawerVisible {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            hideDrawer()
                        }
                }

                VStack {
                    Spacer()
                    VStack {
                        Capsule()
                            .frame(width: 40, height: 6)
                            .foregroundColor(.gray)
                            .padding(.top, 8)

                        VStack(alignment: .leading)  {
                            HStack(spacing: 40) {
                                VStack(alignment: .leading) {
                                    Text("From")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .padding()
                                    Text("\(originAddress)")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .padding(.leading, 16)
                                }
                                VStack(alignment: .leading) {
                                    Text("To")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .padding()
                                    Text("\(destinationAddress)")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .padding(.leading, 16)
                                }
                            }

                            VStack(alignment: .leading, spacing: 3) {
                                Text("Nearby Rides")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical)
                            .padding(.leading)

                            ScrollView(.horizontal) {
                                HStack(spacing: 15) {
                                    ForEach(cars, id: \.carName) { car in
                                        VStack {
                                            Image(car.images.first ?? "")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 250, height: 142)
                                            ZStack {
                                                Text(car.carName)
                                                    .font(Font.custom("SF Pro", size: 12))
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                Text("\(DateFormatter.localizedString(from: Calendar.current.date(byAdding: .minute, value: 10, to: Date())!, dateStyle: .none, timeStyle: .short)) • 10 min")
                                                    .font(Font.custom("SF Pro", size: 12))
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                            }
                                            .padding(4)
                                        }
                                        .onTapGesture {
                                            selectedCar = car
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)

                            if let car = selectedCar {
                                Button {
                                    navigationPath.append(car)
                                } label: {
                                    HStack {
                                        Text("Confirm \(car.carName)")
                                            .foregroundStyle(.white)
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: 60)
                                    .background(.blue)
                                    .cornerRadius(20)
                                    .padding()
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                }
                            }
                        }
                        .navigationDestination(for: CarDetails.self) { car in
                            RidesDetailView(
                                distanceCost: 100.00,
                                origin: originAddress,
                                destinaiton: destinationAddress,
                                carModel: car,
                                navigationPath: $navigationPath
                            )
                            .navigationBarBackButtonHidden(true)
                            .toolbar(.hidden, for: .tabBar)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "1C1C1E"))
                    .cornerRadius(20)
                    .offset(y: drawerOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.translation.height > 0 {
                                    self.drawerOffset =
                                        value.translation.height + UIScreen.main
                                        .bounds.height * 0.95
                                } else {
                                    self.drawerOffset = max(
                                        0,
                                        UIScreen.main.bounds.height * 0.3
                                            + value.translation.height)
                                }
                            }
                            .onEnded { value in
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    if value.translation.height > 100 {
                                        isDrawerVisible = false

                                        hideDrawer()
                                    } else {
                                        isDrawerVisible = true
                                        drawerOffset = 0
                                    }
                                }
                            }
                    )
                    .transition(.move(edge: .bottom))
                    .animation(
                        .easeInOut(duration: 0.5), value: isDrawerVisible)
                }
            }
            .onAppear {
                loadCarData()
                searchCompleter.delegate = SearchCompleterDelegate(
                    searchResults: $searchResults)

                // Fetch the user's current location
                region = MKCoordinateRegion(
                    center: locationManager.userLocation
                        ?? CLLocationCoordinate2D(
                            latitude: 29.7295, longitude: -95.3443),
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.09, longitudeDelta: 0.09)
                )

                checkDrawerVisibility()  // Ensure drawer is updated on load if addresses are set
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
            showDrawer()  // Both addresses are filled, show the drawer
        } else if !originAddress.isEmpty || !destinationAddress.isEmpty {
            // At least one address is filled, keep the drawer hidden but allow it to be reopened
            if !isDrawerVisible {
                drawerOffset = UIScreen.main.bounds.height * 0.95  // Drawer closer to the bottom
            }
        } else {
            hideDrawer()
        }
    }

    func hideDrawer() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isDrawerVisible = false
            drawerOffset = UIScreen.main.bounds.height * 0.38  // Only capsule visible
        }
    }

    func calculateRouteToDestination() {
        guard let userLocation = locationManager.userLocation else { return }

        let request = MKDirections.Request()
        request.source = MKMapItem(
            placemark: MKPlacemark(coordinate: userLocation))

        // Geocode destination to get coordinates
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(destinationAddress) { placemarks, error in
            guard let placemark = placemarks?.first,
                let destinationLocation = placemark.location
            else { return }

            request.destination = MKMapItem(
                placemark: MKPlacemark(
                    coordinate: destinationLocation.coordinate))
            request.transportType = .automobile

            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                if let route = response?.routes.first {
                    self.route = route  // Store the route to draw on the map
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
