import CoreLocation
import Foundation
import MapKit
import SwiftUI

struct RidesView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass:
        UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass:
        UserInterfaceSizeClass?
    @StateObject private var locationSearchVM: LocationSearchViewModel =
        LocationSearchViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var searchCompleter = MKLocalSearchCompleter()

    @State public var truncDestinationAddress: String = ""
    @State public var fullDestinationAddress: String = ""
    @State public var truncOriginAddress: String = ""
    @State public var fullOriginAddress: String = ""
    @State public var driveTime: String = "Next Stop?"
    @State private var selectedCar: CarDetails?
    @State private var navigationPath = NavigationPath()
    @State private var distance: Double?

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

    func calculateDistance(origin: String, destination: String) async -> Double?
    {
        let geocoder = CLGeocoder()

        do {
            // Geocode origin address
            let originPlacemarks = try await geocoder.geocodeAddressString(
                origin)
            guard let originPlacemark = originPlacemarks.first,
                let originLocation = originPlacemark.location
            else {
                print("Error: Unable to find origin location")
                return nil
            }

            // Geocode destination address
            let destinationPlacemarks = try await geocoder.geocodeAddressString(
                destination)
            guard let destinationPlacemark = destinationPlacemarks.first,
                let destinationLocation = destinationPlacemark.location
            else {
                print("Error: Unable to find destination location")
                return nil
            }

            // Create MKDirections request
            let request = MKDirections.Request()
            request.source = MKMapItem(
                placemark: MKPlacemark(coordinate: originLocation.coordinate))
            request.destination = MKMapItem(
                placemark: MKPlacemark(
                    coordinate: destinationLocation.coordinate))
            request.transportType = .automobile

            // Calculate directions
            let directions = MKDirections(request: request)
            let response = try await directions.calculate()
            if let route = response.routes.first {
                return Double(String(format: "%.2f", route.distance / 1609)) // Distance in miles, converted from meters
            } else {
                print("Error: No route found")
                return nil
            }
        } catch {
            print("Error calculating distance: \(error.localizedDescription)")
            return nil
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
                                RouteMapView(
                                    originAddress: $truncOriginAddress,
                                    fullOriginAddress: $fullOriginAddress,
                                    destinationAddress: $truncDestinationAddress
                                )
                                .environmentObject(locationSearchVM)
                                .frame(maxWidth: .infinity, maxHeight: 720)
                                .edgesIgnoringSafeArea(.all)

                                VStack {
                                    if fullDestinationAddress.isEmpty {
                                        Text(
                                            "\(Image(systemName: "magnifyingglass")) Where To?"
                                        )
                                        .onTapGesture {
                                            navigationPath.append(
                                                "locationSearch")
                                        }
                                        .frame(
                                            maxWidth: .infinity, maxHeight: 25
                                        )
                                        .foregroundStyle(.white)
                                        .padding(20)
                                        .background(
                                            Color(hex: "303033").opacity(0.8)
                                        )
                                        .cornerRadius(24)
                                        .padding(.horizontal, 32)
                                        .padding(.top, 10)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                    } else {
                                        Text(
                                            "\(Image(systemName: "magnifyingglass")) \(fullDestinationAddress)"
                                        )
                                        .onTapGesture {
                                            navigationPath.append(
                                                "locationSearch")
                                        }
                                        .frame(
                                            maxWidth: .infinity,
                                            maxHeight: 25
                                        )
                                        .foregroundStyle(.white)
                                        .padding(20)
                                        .background(
                                            Color(hex: "303033")
                                                .opacity(0.8)
                                        )
                                        .cornerRadius(24)
                                        .padding(.horizontal, 32)
                                        .padding(.top, 10)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(
                                            .center)

                                    }
                                }
                                .padding(.top, 15)
                            }
                        }
                        .frame(maxHeight: .infinity)
                    }
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

                        VStack(alignment: .leading) {
                            HStack(spacing: 40) {
                                VStack(alignment: .leading) {
                                    Text("From")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .padding()
                                    Text("\(fullOriginAddress)")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .padding(.leading, 16)
                                }
                                VStack(alignment: .leading) {
                                    Text("To")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .padding()
                                    Text("\(fullDestinationAddress)")
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
                                                    .font(
                                                        Font.custom(
                                                            "SF Pro", size: 12)
                                                    )
                                                    .foregroundColor(.white)
                                                    .frame(
                                                        maxWidth: .infinity,
                                                        alignment: .leading)
                                                Text(
                                                    "\(DateFormatter.localizedString(from: Calendar.current.date(byAdding: .minute, value: 10, to: Date())!, dateStyle: .none, timeStyle: .short)) • 10 min"
                                                )
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
                                    .transition(
                                        .move(edge: .bottom).combined(
                                            with: .opacity))
                                }
                            }
                        }
                        .navigationDestination(for: CarDetails.self) { car in
                            if let distance = distance {
                                RidesDetailView(
                                    distance: distance,
                                    origin: truncOriginAddress,
                                    destinaiton: truncDestinationAddress,
                                    carModel: car,
                                    navigationPath: $navigationPath
                                )
                                .navigationBarBackButtonHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                            }
                        }
                        .navigationDestination(for: String.self) {
                            destination in
                            if destination == "locationSearch" {
                                RidesLocationSearchView(
                                    navigationPath: $navigationPath,
                                    originAddress: $truncOriginAddress,
                                    destinationAddress: $truncDestinationAddress,
                                    fullOriginAddress: $fullOriginAddress,
                                    fullDestinationAddress: $fullDestinationAddress
                                )
                                .environmentObject(locationSearchVM)
                                .navigationBarBackButtonHidden(true)

                            }
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
                checkDrawerVisibility()  // Ensure drawer is updated on load if addresses are set
            }
            .onChange(of: truncOriginAddress) {
                checkDrawerVisibility()
            }
            .onChange(of: truncDestinationAddress) {
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
        if !fullOriginAddress.isEmpty && !fullDestinationAddress.isEmpty {
            showDrawer()
            Task {
                print("Origin: \(fullOriginAddress), Destination: \(fullDestinationAddress)")
                distance = await calculateDistance(
                    origin: fullOriginAddress, destination: fullDestinationAddress)
                
            }
        } else if !fullOriginAddress.isEmpty || !fullDestinationAddress.isEmpty {
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

}

#Preview {
    RidesView()
}
