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
        flightLocation: CLLocationCoordinate2D(),
        responseModel: ResponseModel(
            response: .accepted,
            ID: "321",
            reason: "dsa"
        )
    )
    
    init(formModel: RequestFormModel) {
        super.init()
        
        self.formModel = formModel

    }
}
