//
//  RouteMapView.swift
//  iRoute
//
//  Created by Sage Turner on 11/19/24.
//

import Foundation
import MapKit
import SwiftUI

struct RouteMapView: UIViewRepresentable {

    let mapView = MKMapView()
    let locationManager = LocationManager()

    @EnvironmentObject private var locationSearchVM: LocationSearchViewModel
    @Binding var originAddress: String
    @Binding var fullOriginAddress: String
    @Binding var destinationAddress: String

    // Closures for sending back updated addresses
    var onAddressesUpdated: ((String, String) -> Void)?

    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        return mapView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let coordinate = locationSearchVM.selectedLocationCoordinate {
            print("DEBUG: Selected location in map view is \(coordinate)")
            context.coordinator.addAndSelectAnnotation(
                withCoordinate: coordinate)
            context.coordinator.configurePolyline(
                withDestinationCoordinate: coordinate)

            // Fetch address for destination coordinate
            fetchAddress(from: coordinate) { address in
                if let address = address {
                    destinationAddress = address
                    onAddressesUpdated?(originAddress, address)
                }
            }
        }
    }

    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }

    // Helper to fetch address from a coordinate
    private func fetchAddress(
        from coordinate: CLLocationCoordinate2D,
        completion: @escaping (String?) -> Void
    ) {
        let location = CLLocation(
            latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print(
                    "DEBUG: Failed to fetch address - \(error.localizedDescription)"
                )
                completion(nil)
                return
            }
            let address = placemarks?.first?.name
            completion(address)
        }
    }
}

extension RouteMapView {
    class MapCoordinator: NSObject, MKMapViewDelegate {

        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?

        // MARK: - Properties
        let parent: RouteMapView

        // MARK: - Lifecycle
        init(parent: RouteMapView) {
            self.parent = parent
            super.init()
        }

        // MARK: - MKMapViewDelegate
        func mapView(
            _ mapView: MKMapView, didUpdate userLocation: MKUserLocation
        ) {
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.05,
                    longitudeDelta: 0.05
                )
            )
            self.currentRegion = region
            parent.mapView.setRegion(region, animated: true)

            // Fetch address for user location (origin)
            let location = CLLocation(
                latitude: userLocation.coordinate.latitude,
                longitude: userLocation.coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print(
                        "DEBUG: Failed to fetch origin address - \(error.localizedDescription)"
                    )
                    return
                }
                if let address = placemarks?.first?.name {
                    self.parent.originAddress = address
                    self.parent.onAddressesUpdated?(
                        address, self.parent.destinationAddress)
                }

                if let placemark = placemarks?.first {
                    var addressParts: [String] = []

                    // Append components if available
                    if let subThoroughfare = placemark.subThoroughfare {
                        addressParts.append(subThoroughfare)
                    }
                    if let thoroughfare = placemark.thoroughfare {
                        addressParts.append(thoroughfare)
                    }
                    if let locality = placemark.locality {
                        addressParts.append(locality)
                    }
                    if let administrativeArea = placemark.administrativeArea {
                        addressParts.append(administrativeArea)
                    }
                    if let postalCode = placemark.postalCode {
                        addressParts.append(postalCode)
                    }

                    // Join the components to create the full address
                    let fullAddress = addressParts.joined(separator: ", ")

                    if let name = placemark.name {
                        self.parent.originAddress =
                            placemark.name ?? fullAddress
                        self.parent.fullOriginAddress = fullAddress
                        self.parent.onAddressesUpdated?(
                            fullAddress, self.parent.destinationAddress)
                    }

                }
            }
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay)
            -> MKOverlayRenderer
        {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .black
            polyline.lineWidth = 6
            return polyline
        }

        // MARK: - Helpers
        func addAndSelectAnnotation(
            withCoordinate coordinate: CLLocationCoordinate2D
        ) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)

            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            parent.mapView.addAnnotation(anno)
            parent.mapView.selectAnnotation(anno, animated: true)

            parent.mapView.showAnnotations(
                parent.mapView.annotations, animated: true)
        }

        func getDestinationRoute(
            from userLocation: CLLocationCoordinate2D,
            to destination: CLLocationCoordinate2D,
            completion: @escaping (MKRoute) -> Void
        ) {
            let userPlacemark = MKPlacemark(coordinate: userLocation)
            let destinationPlacemark = MKPlacemark(coordinate: destination)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userPlacemark)
            request.destination = MKMapItem(placemark: destinationPlacemark)

            let directions = MKDirections(request: request)

            directions.calculate { response, error in
                if let error = error {
                    print(
                        "DEBUG: Failed to get directions with error - \(error.localizedDescription)"
                    )
                    return
                }

                guard let route = response?.routes.first else { return }
                completion(route)
            }
        }

        func configurePolyline(
            withDestinationCoordinate coordinate: CLLocationCoordinate2D
        ) {
            guard let userLocationCoordinate = self.userLocationCoordinate
            else { return }
            getDestinationRoute(from: userLocationCoordinate, to: coordinate) {
                route in
                self.parent.mapView.addOverlay(route.polyline)
            }
        }

        func clearMapView() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
    }
}
