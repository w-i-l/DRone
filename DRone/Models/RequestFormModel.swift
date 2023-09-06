//
//  RequestFormModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 16.08.2023.
//

import Foundation
import CoreLocation

struct RequestFormModel {

    let firstName: String
    let lastName: String
    let CNP: String
    let birthday: Date
    let currentLocation: CLLocationCoordinate2D
    let serialNumber: String
    let droneType: DroneType
    let takeoffTime: Date
    let landingTime: Date
    let flightLocation: CLLocationCoordinate2D
    var flightDate = Date()
    var flightAddress: (mainAddress: String, secondaryAddress: String) = ("", "")
    var responseModel: ResponseModel
}

extension RequestFormModel: Encodable {
    
    enum CodingKeys: String, CodingKey {
        
        case firstName = "first-name"
        case lastName = "last-name"
        case CNP = "cnp"
        case birthday = "birthday"
        case currentLocationLatitude = "current-location-latitude"
        case currentLocationLongitude = "current-location-longitude"
        case serialNumber = "serial-number"
        case droneType = "drone-type"
        case takeoffTime = "takeoff-time"
        case landingTime = "landing-time"
        case flightLocationLatitude = "flight-location-latitude"
        case flightLocationLongitude = "flight-location-longitude"
    }
    
    public func encode(to encoder: Encoder) throws {
        
        let birthdayFormatter = DateFormatter()
        birthdayFormatter.dateFormat = "dd-MM-yyyy"
        
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH:mm"
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.firstName, forKey: .firstName)
        try container.encode(self.lastName, forKey: .lastName)
        try container.encode(self.CNP, forKey: .CNP)
        try container.encode(birthdayFormatter.string(from: birthday), forKey: .birthday)
        try container.encode(self.serialNumber, forKey: .serialNumber)
        try container.encode(self.droneType.associatedValues.type, forKey: .droneType)
        try container.encode(hourFormatter.string(from: takeoffTime), forKey: .takeoffTime)
        try container.encode(hourFormatter.string(from: landingTime), forKey: .landingTime)
        try container.encode(self.currentLocation.latitude, forKey: .currentLocationLatitude)
        try container.encode(self.currentLocation.longitude, forKey: .currentLocationLongitude)
        try container.encode(self.flightLocation.latitude, forKey: .flightLocationLatitude)
        try container.encode(self.flightLocation.longitude, forKey: .flightLocationLongitude)
    }
    
}

extension RequestFormModel: Identifiable {
    var id: String {
        return CNP + firstName + lastName + responseModel.response.rawValue + serialNumber + String.init(describing: takeoffTime) + responseModel.ID
    }
}

extension RequestFormModel: Hashable {
    static func == (lhs: RequestFormModel, rhs: RequestFormModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}

extension RequestFormModel {
    func updatedRequestStatus(state: ResponseResult) -> RequestFormModel {
        RequestFormModel(
            firstName: self.firstName ,
            lastName: self.lastName ,
            CNP: self.CNP ,
            birthday: self.birthday ,
            currentLocation: self.currentLocation ,
            serialNumber: self.serialNumber ,
            droneType: self.droneType ,
            takeoffTime: self.takeoffTime ,
            landingTime: self.landingTime ,
            flightLocation: self.flightLocation,
            flightDate: self.flightDate,
            flightAddress: flightAddress,
            responseModel: ResponseModel(
                response: state,
                ID: self.responseModel.ID,
                reason: self.responseModel.reason
            )
        )
    }
}
