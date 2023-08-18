//
//  RequestViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 10.08.2023.
//

import SwiftUI
import CoreLocation
import Combine

enum DroneType: CaseIterable {
    case agricultural
    case toy
    case photography
    case military
    
    var associatedValues: (type: String, weight: ClosedRange<Double>) {
        switch self {
        case .agricultural:
            return ("Agrar", 1.5...2.5)
        case .toy:
            return ("Toy", 0.1...0.3)
        case .photography:
            return ("Photography", 0.4...1)
        case .military:
            return ("Military", 3...5.5)
            
        }
    }
}

class RequestViewModel: BaseViewModel {
    
    @Published var ID: String = String(UUID().uuidString.prefix(8))
    
    // personal
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var CNP: String = ""
    
    // additional
    @Published var birthdayDate: Date = .init()
    @Published var currentLocation: (mainAdress: String, secondaryAdress: String) = ("", "")
    
    // drone
    @Published var serialNumber: String = ""
    @Published var droneType: DroneType = .toy
    @Published var isDroneModalShown: Bool = false
    
    // flight
    @Published var takeoffTime: Date = Date()
    @Published var landingTime: Date = Date()
    @Published var flightLocation: (mainAdress: String, secondaryAdress: String) = ("", "")
    @Published var flightDate: Date = Date()
    
    // response sttaus
    @Published var response: ResponseResult = .pending
    @Published var showNavigationLink: Bool = false
    
    var sunsetHourToday: Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let sunsetFormatter = DateFormatter()
        sunsetFormatter.dateFormat = "dd/MM/yyyy, HH:mm"
        return sunsetFormatter.date(from: "\(dateFormatter.string(from: self.flightDate) ), 20:00")!
    }
    // 10 min
    let minimumFlightTime: TimeInterval = 10 * 60
    // 30 days
    let maximumDayToRequest: TimeInterval = 3600 * 24 * 30
    
    var flightCoordinates: CurrentValueSubject<CLLocationCoordinate2D?, Never> = .init(nil)
    private var flightCoordinatesBinding: Binding<CLLocationCoordinate2D?> {
        Binding<CLLocationCoordinate2D?>(
            get: { self.flightCoordinates.value },
            set: {
                newValue in self.flightCoordinates.value = newValue
                LocationService.shared.getAdressForLocation(location: newValue!)
                    .receive(on: DispatchQueue.main)
                    .sink { _ in
                        
                    } receiveValue: { newAdress in
                        self.flightLocation = newAdress
                    }
                    .store(in: &self.bag)
            }
        )
    }
    
    // all flights
    @Published var allFlightsRequest = [RequestFormModel]()
    
    var upcomingFlights: [RequestFormModel] {
        allFlightsRequest.sorted(by: { $0.flightDate > $1.flightDate }).filter { $0.flightDate >= Date() }
    }
        
    var completedFlights: [RequestFormModel] {
        allFlightsRequest.sorted(by: { $0.flightDate > $1.flightDate }).filter { $0.flightDate < Date() }
    }
    
    @Published var screenIndex = 0

    var changeLocationViewModel: ChangeLocationViewModel = .init(adressToFetchLocation: .constant(nil))
    
    override init() {
        super.init()
        
        changeLocationViewModel = ChangeLocationViewModel(adressToFetchLocation: self.flightCoordinatesBinding)

        AppService.shared.screenIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.screenIndex = value
            }
            .store(in: &bag)
        
        LocationService.shared.getAdressForCurrentLocation()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] value in
                self?.currentLocation = value
                self?.flightLocation = value
            }
            .store(in: &bag)

    }
    
    func getResponse() {
        
        var formModel = RequestFormModel(
            firstName: firstName,
            lastName: lastName,
            CNP: CNP,
            birthday: birthdayDate,
            currentLocation: CLLocationCoordinate2D(),
            serialNumber: serialNumber,
            droneType: droneType,
            takeoffTime: takeoffTime,
            landingTime: landingTime,
            flightLocation: CLLocationCoordinate2D(),
            flightDate: flightDate,
            requestState: .accepted,
            flightAdress: self.flightLocation
        )
        
        ResponseService.shared.getResponse(formModel: formModel)
        .receive(on: DispatchQueue.main)
        .sink { _ in
            
        } receiveValue: { [weak self] value in
            self?.response = value.response
            formModel.requestID = String(value.ID.prefix(8))
            self?.ID = String(value.ID.prefix(8))
            self?.allFlightsRequest.append(formModel.updatedRequestStatus(state: value.response))
            
        }
        .store(in: &bag)

    }
    
    func clearData() {
        firstName = ""
        lastName = ""
        CNP = ""
        birthdayDate = Date()
        serialNumber = ""
        droneType = .toy
        isDroneModalShown = false
        takeoffTime = Date()
        landingTime = Date()
        response = .pending
        flightDate = Date()
        ID = String(UUID().uuidString.prefix(8))
        
        showNavigationLink = false
        
        LocationService.shared.getAdressForCurrentLocation()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] value in
                self?.currentLocation = value
                self?.flightLocation = value
            }
            .store(in: &bag)
    }
}
