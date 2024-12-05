//
//  LocationSearchService.swift
//  RideApp
//
//  Created by Sage Turner on 11/21/24.
//

import MapKit
import SwiftUI
import Combine

class LocationSearchService: NSObject, ObservableObject {
    @Published var searchResults: [MKLocalSearchCompletion] = []
    private var completer: MKLocalSearchCompleter
    
    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        completer.delegate = self
    }
    
    func updateSearchQuery(_ query: String) {
        completer.queryFragment = query
    }
}

extension LocationSearchService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error getting search completions: \(error.localizedDescription)")
    }
}
