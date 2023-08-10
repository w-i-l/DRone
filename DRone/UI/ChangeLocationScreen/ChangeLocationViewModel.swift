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
    var adressToFetchLocation: Binding<CLLocationCoordinate2D?>
    
    init(adressToFetchLocation: Binding<CLLocationCoordinate2D?>) {
        self.adressToFetchLocation = adressToFetchLocation
        self.searchLocationViewModel = SearchingViewModel(adressToFetchLocation: adressToFetchLocation)
    }
    
}

