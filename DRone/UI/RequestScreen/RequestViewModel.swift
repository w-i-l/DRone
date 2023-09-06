//
//  RequestViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 10.08.2023.
//

import SwiftUI
import CoreLocation
import Combine
import BottomSheet

enum DroneType: CaseIterable {
    case agricultural
    case toy
    case photography
    case military
    
    var associatedValues: (type: String, weight: ClosedRange<Double>) {
        switch self {
        case .agricultural:
            return ("Agricultural", 1.5...2.5)
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
    @Published var firstNameError: String = "Enter a valid first name!"
    @Published var lastNameError: String = "Enter a valid last name!"
    @Published var cnpError: String = "Enter a valid cnp!"
    
    func firstNameValidation() -> Bool {
        
        if !containsOnlyLetters(firstName) {
            firstNameError = "First name should contain only letters!"
            return false
        } else if firstName.contains(where: { $0 == " " }) {
            firstNameError = "Enter only a first name!"
            return false
        }
        
        return onlyStringValidation(string: firstName)
    }
    
    func lastNameValidation() -> Bool {
        
        if !containsOnlyLetters(lastName) {
            lastNameError = "Last name should contain only letters!"
            return false
        } else if firstName.contains(where: { $0 == " " }) {
            lastNameError = "Enter only a last name!"
            return false
        }
        
        return onlyStringValidation(string: lastName)
    }
    
    func cnpValidation() -> Bool {
        if !containsOnlyNumbers(CNP) {
            cnpError = "CNP should contain only numbers!"
            return false
        } else if CNP.count != 13 {
            cnpError = "CNP should have 13 characters!"
            return false
        } else if getBirthDayFromCNP() == nil {
            cnpError = "Your birthday isn't valid!"
            return false
        } else if !["1", "2", "5", "6"].contains(CNP[CNP.startIndex]) {
            cnpError = "Your first digit must represent your sex!"
            return false
        }
        
        return personalNumberValidation(personalNumber: CNP)
    }
    
    // additional
    @Published var birthdayDate: Date = .init()
    @Published var currentLocation: (mainAddress: String, secondaryAddress: String) = ("", "")
    
    // drone
    @Published var serialNumber: String = ""
    @Published var serialNumberError: String = "Enter a valid serial number"
    @Published var droneType: DroneType = .toy
    @Published var isDroneModalShown: Bool = false
    @Published var bottomSheetPosition: BottomSheetPosition = .hidden
    
    func serialNumberValidation() -> Bool {
        if !containsOnlyLettersAndNumbers(serialNumber) {
            serialNumberError = "Serial number should contain only alphanumeric characters!"
            return false
        } else if serialNumber.count != 8 {
            serialNumberError = "Serial number should be 8 characters long!"
            return false
        }
        
        return true
    }
    
    // flight
    @Published var takeoffTime: Date = Date()
    @Published var landingTime: Date = Date()
    @Published var flightLocation: (mainAddress: String, secondaryAddress: String) = ("", "")
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
    // back 18 years in past
    let maximumBirthdayDate: TimeInterval = 3600 * 24 * 30 * 12 * 18
    // 80 years in past
    let minimumBirthdayDate: TimeInterval = 3600 * 24 * 30 * 12 * 80
    
    var flightCoordinates: CurrentValueSubject<CLLocationCoordinate2D?, Never> = .init(nil)
    private var flightCoordinatesBinding: Binding<CLLocationCoordinate2D?> {
        Binding<CLLocationCoordinate2D?>(
            get: { self.flightCoordinates.value },
            set: { newValue in
                
                self.flightCoordinates.value = newValue
                LocationService.shared.getAddressForLocation(location: newValue!)
                    .receive(on: DispatchQueue.main)
                    .sink { _ in
                        
                    } receiveValue: { newAddress in
                        self.flightLocation = newAddress
                    }
                    .store(in: &self.bag)
            }
        )
    }
    
    // buttonPressed for all form screens
    var personalNextButtonPressed: CurrentValueSubject<Bool, Never> = .init(false)
    var additionalNextButtonPressed: CurrentValueSubject<Bool, Never> = .init(false)
    var droneNextButtonPressed: CurrentValueSubject<Bool, Never> = .init(false)
    var flightNextButtonPressed: CurrentValueSubject<Bool, Never> = .init(false)
    
    // all flights
    @Published var allFlightsRequest = [RequestFormModel]()
    @Published var fetchingState: FetchingState = .loading
    
    @Published var shouldDeleteUpcomingFlight: BottomSheetPosition = .hidden
    @Published var flightIDToBeDeleted: String = ""
    
    var upcomingFlights: [RequestFormModel] {
        allFlightsRequest.sorted(by: { $0.flightDate > $1.flightDate }).filter { $0.flightDate >= Date() }
    }
        
    var completedFlights: [RequestFormModel] {
        allFlightsRequest.sorted(by: { $0.flightDate > $1.flightDate }).filter { $0.flightDate < Date() }
    }
    
    @Published var screenIndex = 0

    var changeLocationViewModel: ChangeLocationViewModel = .init(addressToFetchLocation: .constant(nil))
    
    override init() {
        
        self.fetchingState = .loading
        
        self.flightCoordinates.value = LocationService.shared.locationManager.location?.coordinate
        
        super.init()
        
        changeLocationViewModel = ChangeLocationViewModel(addressToFetchLocation: self.flightCoordinatesBinding)

        AppService.shared.screenIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.screenIndex = value
            }
            .store(in: &bag)
        
        LocationService.shared.getAddressForCurrentLocation()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] value in
                self?.currentLocation = value
                self?.flightLocation = value
            }
            .store(in: &bag)
        
        FirebaseService.shared.allFlightsRequests
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.allFlightsRequest = value
                self?.fetchingState = .loaded
            }
            .store(in: &bag)

    }
    
    func fetchAllFlightsFor(user uid: String) {
        
        self.fetchingState = .loading
        
        FirebaseService.shared.fetchFlightRequestsFor(user: uid)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] value in
                FirebaseService.shared.allFlightsRequests.value = value
                self?.fetchingState = .loaded
            }
            .store(in: &bag)
    }
    
    func getResponse() {
        
        guard let location = LocationService.shared.locationManager.location?.coordinate else {
            print("No location")
            return
        }
        
        var formModel = RequestFormModel(
            firstName: firstName,
            lastName: lastName,
            CNP: CNP,
            birthday: birthdayDate,
            currentLocation: location,
            serialNumber: serialNumber,
            droneType: droneType,
            takeoffTime: takeoffTime,
            landingTime: landingTime,
            flightLocation: flightCoordinates.value!,
            flightDate: flightDate,
            flightAddress: self.flightLocation,
            responseModel: ResponseModel(
                response: .pending,
                ID: ID,
                reason: ""
            )
        )
        
        self.allFlightsRequest.append(formModel)
        
        ResponseService.shared.getResponse(formModel: formModel)
        .receive(on: DispatchQueue.main)
        .sink { _ in
            
        } receiveValue: { [weak self] value in
            // always pending
            self?.response = .pending
            formModel.responseModel.reason = value.reason
            FirebaseService.shared.allFlightsRequests.value.append(formModel)
        }
        .store(in: &bag)

    }
    
    func deleteFlightRequest(ID: String) {
        FirebaseService.shared.deleteFlyRequest(ID: ID)
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
        
        personalNextButtonPressed.value = false
        additionalNextButtonPressed.value = false
        droneNextButtonPressed.value = false
        
        showNavigationLink = false
        
        LocationService.shared.getAddressForCurrentLocation()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] value in
                self?.currentLocation = value
                self?.flightLocation = value
            }
            .store(in: &bag)
    }
    
    
    func syncDataWithCurrentUserInfo() {
        if let user = AppService.shared.user.value {
            firstName = user.firstName
            lastName = user.lastName
            CNP = user.CNP
        }
    }
    
    func getBirthDayFromCNP() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let yearStartIndex = CNP.index(CNP.startIndex, offsetBy: 1)
        let yearEndIndex = CNP.index(CNP.startIndex, offsetBy: 2)
        let last2DigitsOfBirthdayYear = String(CNP[yearStartIndex...yearEndIndex])
        let birthdayYear = "\(Int(last2DigitsOfBirthdayYear)! > 23 ? "19" : "20")\(last2DigitsOfBirthdayYear)"
        
        let monthStartIndex = CNP.index(CNP.startIndex, offsetBy: 3)
        let monthEndIndex = CNP.index(CNP.startIndex, offsetBy: 4)
        let birthdayMonth = String(CNP[monthStartIndex...monthEndIndex])
        
        let dayStartIndex = CNP.index(CNP.startIndex, offsetBy: 5)
        let dayEndIndex = CNP.index(CNP.startIndex, offsetBy: 6)
        let birthdayDay = String(CNP[dayStartIndex...dayEndIndex])
        
        let birthdayDateFromCNP = "\(birthdayDay)/\(birthdayMonth)/\(birthdayYear)"
        return dateFormatter.date(from: birthdayDateFromCNP)
        
    }
    
    func serialNumberValidation(serial: String) -> Bool {
        return serial.count == 8
    }
        
    func personalNumberValidation(personalNumber: String) -> Bool {
        return personalNumber.count == 13 && containsOnlyNumbers(personalNumber)
    }
    
    func postFlightRequestFor() {
        guard let location = LocationService.shared.locationManager.location?.coordinate else {
            print("No location")
            return
        }
        
        var formModel = RequestFormModel(
            firstName: firstName,
            lastName: lastName,
            CNP: CNP,
            birthday: birthdayDate,
            currentLocation: location,
            serialNumber: serialNumber,
            droneType: droneType,
            takeoffTime: takeoffTime,
            landingTime: landingTime,
            flightLocation: flightCoordinates.value!,
            flightDate: flightDate,
            flightAddress: self.flightLocation,
            responseModel: ResponseModel(
                response: allFlightsRequest.last!.responseModel.response,
                ID: allFlightsRequest.last!.responseModel.ID,
                reason: allFlightsRequest.last!.responseModel.reason
            )
        )
        
        FirebaseService.shared.postFlightRequestFor(
            user: AppService.shared.user.value!.uid,
            formModel: formModel
        )
        
        UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "user")
    }
}
