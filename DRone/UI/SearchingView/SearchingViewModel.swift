//
//  SearchingViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 09.08.2023.
//

import Foundation
import SwiftUI
import MapKit
import Combine
import GooglePlaces
import SwiftyJSON

class SearchingViewModel: BaseViewModel {
    
    @Published var textSearched: String = ""
    @Published var selectedAddress: (addressName: String, addressID: String) = ("", "")
    @Published var predictedLocations: [(addressName: String, addressID: String)] = []
    
    @Binding var addressToFetchLocation: CLLocationCoordinate2D?
    
    let showCurrentLocation: Bool
    
    init(addressToFetchLocation: Binding<CLLocationCoordinate2D?>, showCurrentLocation: Bool = true) {
        self._addressToFetchLocation = addressToFetchLocation
        self.showCurrentLocation = showCurrentLocation
    }
    
    func searchForNearbyLocations() {
        LocationService.shared.getPredictionsFromInput(textSearched: textSearched)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] value in
                self?.predictedLocations = value
            }
            .store(in: &bag)

    }
    
    func matchLocationWithCurrentLocation(location: CLLocationCoordinate2D) {
        LocationService.shared.getAddressIDForCurrentLocation(location: location)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] value in
                self?.selectedAddress.addressID = value
                self?.updateLocation()
            }
            .store(in: &bag)
        addressToFetchLocation = location
    }
    
    func updateLocation() {
        LocationService.shared.getCoordinatesFromLocationID(ID: selectedAddress.addressID)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] value in
                self?.addressToFetchLocation = value
            }
            .store(in: &bag)

    }
}
