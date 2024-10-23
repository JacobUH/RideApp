//
//  RouteMapView.swift
//  RideApp
//
//  Created by Sage Turner on 10/22/24.
//

import SwiftUI
import MapKit

struct RouteMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var route: MKRoute?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)

        // Remove any existing overlays
        uiView.removeOverlays(uiView.overlays)
        
        // Add the route polyline if available
        if let route = route {
            uiView.addOverlay(route.polyline)
        }
    }

    func makeCoordinator() -> RouteMapViewCoordinator {
        RouteMapViewCoordinator(self)
    }
}

class RouteMapViewCoordinator: NSObject, MKMapViewDelegate {
    var parent: RouteMapView

    init(_ parent: RouteMapView) {
        self.parent = parent
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
