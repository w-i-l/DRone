//
//  FirestoreService.swift
//  DRone
//
//  Created by Mihai Ocnaru on 21.08.2023.
//

import Foundation
import FirebaseFirestore
import Combine
import CoreLocation

class FirebaseService: BaseViewModel {
    
    static let shared: FirebaseService = .init()
    let db = Firestore.firestore()
    
    override private init() {
        super.init()
        
        fetchFlightRequestsFor(user: "Ocnaru Mihai")
            .sink { _ in
                
            } receiveValue: { _ in
                
            }
            .store(in: &bag)

    }
    
    func fetchFlightRequestsFor(user fullName: String) -> Future<[RequestFormModel], Error> {
        Future<[RequestFormModel], Error> { [weak self] promise in
            
            var arrayToReturn: [RequestFormModel] = []
            
            self?.db.collection(fullName).getDocuments(completion: { (querySnapshot, error) in
                guard error == nil else {promise( .failure(error!)); return }
                
                for document in querySnapshot!.documents {
                    let data = document.data()

                    let flightLocation = data["flight-location"] as! GeoPoint
                    let currentLocation = data["current-location"] as! GeoPoint
                    
                    var droneType: DroneType {
                        switch data["drone-type"] as! String {
                        case "Toy":
                            return .toy
                        case "Agricultural":
                            return .agricultural
                        case "Photography":
                            return .photography
                        case "Military":
                            return .military
                        default:
                            return .toy
                        }
                    }

                    var respose: ResponseResult {
                        switch data["response"] as! String {
                        case "accepted" :
                            return .accepted
                        case "rejected":
                            return .pending
                        case "pending":
                            return .pending
                        default:
                            return .pending
                        }
                    }
                    
                    arrayToReturn.append(RequestFormModel(
                        firstName: data["first-name"] as! String,
                        lastName: data["last-name"] as! String,
                        CNP: data["CNP"] as! String,
                        birthday: (data["birthday"] as! Timestamp).dateValue(),
                        currentLocation: CLLocationCoordinate2D(
                            latitude: currentLocation.latitude,
                            longitude: currentLocation.longitude
                            ),
                        serialNumber: data["serial-number"] as! String,
                        droneType: droneType,
                        takeoffTime: (data["takeoff-time"] as! Timestamp).dateValue(),
                        landingTime: (data["landing-time"] as! Timestamp).dateValue(),
                        flightLocation: CLLocationCoordinate2D(
                            latitude: flightLocation.latitude,
                            longitude: flightLocation.longitude
                        ),
                        flightDate: (data["flight-date"] as! Timestamp).dateValue(),
                        flightAdress: (
                            mainAdress: data["flight-adress-secondary"] as! String,
                            secondaryAdress: data["flight-adress-main"] as! String
                        ),
                        responseModel: ResponseModel(
                            response: respose,
                            ID: data["ID"] as! String,
                            reason: data["reason"] as! String
                        )
                    ))
                }
                
                promise(.success(arrayToReturn))
            })
        }
    }
    
    func postFlightRequestFor(user fullName: String, formModel: RequestFormModel) {
        
        let docRef = db.collection(fullName).document()
        
        let docData: [String: Any] = [
            "first-name": formModel.firstName,
            "last-name": formModel.lastName,
            "birthday": Timestamp(date: formModel.birthday),
            "CNP": formModel.CNP,
            "current-location": GeoPoint(
                latitude: formModel.currentLocation.latitude,
                longitude: formModel.currentLocation.longitude
            ),
            "ID": formModel.responseModel.ID,
            "response": formModel.responseModel.response.rawValue,
            "reason": formModel.responseModel.reason,
            "drone-type": formModel.droneType.associatedValues.type,
            "flight-adress-main": formModel.flightAdress.mainAdress,
            "flight-adress-secondary": formModel.flightAdress.secondaryAdress,
            "flight-date": Timestamp(date: formModel.flightDate),
            "flight-location": GeoPoint(
                latitude: formModel.flightLocation.latitude,
                longitude: formModel.flightLocation.longitude
            ),
            "takeoff-time": Timestamp(date: formModel.takeoffTime),
            "landing-time": Timestamp(date: formModel.landingTime),
            "serial-number": formModel.serialNumber
        ]
        
        docRef.setData(docData)
        
    }
}
