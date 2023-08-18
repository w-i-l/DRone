//
//  RequestDetailsViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 17.08.2023.
//

import SwiftUI
import CoreLocation

class RequestDetailsViewModel: BaseViewModel {
    var formModel: RequestFormModel = .init(
        firstName: "",
        lastName: "",
        CNP: "",
        birthday: Date(),
        currentLocation: CLLocationCoordinate2D(),
        serialNumber: "",
        droneType: .toy,
        takeoffTime: Date(),
        landingTime: Date(),
        flightLocation: CLLocationCoordinate2D()
    )
    
    init(formModel: RequestFormModel) {
        super.init()
        
        self.formModel = formModel

    }
}
