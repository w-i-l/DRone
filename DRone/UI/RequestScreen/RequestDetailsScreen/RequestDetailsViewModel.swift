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
    @Published var flightLocationToDisplay: (mainAdress: String, secondaryAdress: String) = ("", "")
    
    init(formModel: RequestFormModel) {
        super.init()
        
        self.formModel = formModel
        
        LocationService.shared.getAdressForLocation(location: formModel.flightLocation)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { value in
                self.flightLocationToDisplay = value
            }
            .store(in: &bag)

    }
}
