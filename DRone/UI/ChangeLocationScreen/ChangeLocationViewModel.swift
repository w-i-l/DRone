//
//  ChangeLocationViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 10.08.2023.
//

import SwiftUI
import CoreLocation
import Combine

class ChangeLocationViewModel: BaseViewModel {

    var searchLocationViewModel: SearchingViewModel
    var addressToFetchLocation: Binding<CLLocationCoordinate2D?>
    
    init(addressToFetchLocation: Binding<CLLocationCoordinate2D?>) {
        self.addressToFetchLocation = addressToFetchLocation
        self.searchLocationViewModel = SearchingViewModel(addressToFetchLocation: addressToFetchLocation)
    }
    
}

