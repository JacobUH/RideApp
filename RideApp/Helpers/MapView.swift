import SwiftUI
import MapKit

struct MapView: View {
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @Binding var selectedTab: Int
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 29.720, longitude: -95.344),
        span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
    )
    
    @State private var showSearchBar = false
    @State private var searchText = ""
    
    var body: some View {
        let orientation = DeviceHelper(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)

        VStack {
            if orientation.isPortrait(device: .iPhone)
                || orientation.isPortrait(device: .iPhonePlusOrMax) {
                
                // iPhone Portrait view
                ZStack(alignment: .top) {
                    // Map centered on Germany
                    Map(coordinateRegion: $region)
                        .frame(maxWidth: .infinity, maxHeight: 700)

                    // Search bar and button
                    searchAndButtonView
                        .padding(.top, 40)
                }
                .edgesIgnoringSafeArea(.all)
                
            } else if orientation.isLandscape(device: .iPhone)
                || orientation.isLandscape(device: .iPhonePlusOrMax) {
                
                // iPhone Landscape view
                ZStack(alignment: .top) {
                    Map(coordinateRegion: $region)
                        .frame(maxWidth: .infinity, maxHeight: 350)

                    // Search bar and button in landscape mode
                    searchAndButtonView
                        .padding(.top, 20)
                }
                .edgesIgnoringSafeArea(.all)
                
            } else if orientation.isPortrait(device: .iPadFull) {
                
                // iPad Portrait view
                ZStack(alignment: .top) {
                    Map(coordinateRegion: $region)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // Search bar and button for iPad
                    searchAndButtonView
                        .padding(.top, 50)
                }
                .edgesIgnoringSafeArea(.all)
                
            } else if orientation.isLandscape(device: .iPadFull) {
                
                // iPad Landscape view
                ZStack(alignment: .top) {
                    Map(coordinateRegion: $region)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // Search bar and button in landscape
                    searchAndButtonView
                        .padding(.top, 100)
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
        .tabItem {
            Image(systemName: "map")
            Text("Map")
        }
        .tag(3)
        .background(
            Color.white.opacity(0.8) // Set the background color of the TabView with some opacity
        )
    }
    
    // The reusable search bar and button view
    private var searchAndButtonView: some View {
        VStack {
            if showSearchBar {
                HStack {
                    TextField("Enter location", text: $searchText, onCommit: {
                        searchLocation()
                    })
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(radius: 4)

                    Button(action: {
                        searchLocation()
                    }) {
                        Text("Search")
                            .padding(.horizontal)
                    }
                    .padding(.leading, 10)
                }
                .padding(.horizontal)
                .transition(.move(edge: .top)) // Animation when showing the search bar
            }

            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        showSearchBar.toggle()
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(.trailing, 20)
                .padding(.top, showSearchBar ? 10 : 40) // Adjust button padding based on search bar visibility
            }
        }
    }

    // Function to handle location search
    func searchLocation() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchText) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                print("No location found or error: \(String(describing: error))")
                return
            }
            // Update the region to the searched location
            withAnimation {
                region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
                )
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewInterfaceOrientation(.portrait)
                .previewDisplayName("Portrait")
            
            ContentView()
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("Landscape Left")
        }
    }
}
