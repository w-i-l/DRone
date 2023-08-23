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
                            return .rejected
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
            "response": formModel.responseModel.response.rawValue.lowercased(),
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
    
    func fetchAllNoFlyZones() -> Future<[NoFlyZoneShape], Error> {
        var arrayToReturn: [NoFlyZoneShape] = []
        return Future<[NoFlyZoneShape], Error> { [weak self] promise in
            
            self?.db.collection("airports").getDocuments(completion: { querrySnapshot, error in
                guard error == nil else {
                    promise(.failure(error!))
                    return
                }
                
                for document in querrySnapshot!.documents {
                    
                    if (document["type"] as! String) == NoFLyZoneGeometricType.circle.rawValue.lowercased() {
                        
                        let center = CLLocationCoordinate2D(
                            latitude: (document["center"] as! GeoPoint).latitude,
                            longitude: (document["center"] as! GeoPoint).longitude
                        )
                        
                        arrayToReturn.append(NoFlyZoneCircle(
                            geometrycType: .circle,
                            type: .match(zoneType: document["zone-type"] as! String),
                            center: center,
                            radius: document["radius"] as! Double
                        ))
                        
                    } else if (document["type"] as! String) == NoFLyZoneGeometricType.polygon.rawValue.lowercased() {
                        
                        var coordinates: [CLLocationCoordinate2D] = []
                        
                        for location in (document["coordinates"] as! Array<GeoPoint>){
                            coordinates.append(CLLocationCoordinate2D(
                                latitude: location.latitude,
                                longitude: location.longitude
                            ))
                        }
                        
                        arrayToReturn.append(NoFlyZonePolygon(
                            geometrycType: .polygon,
                            type: .match(zoneType: document["zone-type"] as! String),
                            coordinates: coordinates
                        ))
                    }
                    
                    
                }
                
                promise(.success(arrayToReturn))
            })
        }
    }
    
    func generateSimulatedNoFlyZonePolygon() -> NoFlyZonePolygon {

        // we draw an hexagon with points
        /*
            E   D
         F         C
            A   B
         */
        
        let hexagonSideLengh: Double = Double.random(in: 0.1...0.4)
        let pointA = CLLocationCoordinate2D(
            latitude: Double.random(in: -90...90),
            longitude: Double.random(in: -180...180)
        )
        
        let pointB = CLLocationCoordinate2D(
            latitude: pointA.latitude + hexagonSideLengh,
            longitude: pointA.longitude
        )
        
        let pointC = CLLocationCoordinate2D(
            latitude: pointA.latitude + (3 * hexagonSideLengh / 2),
            longitude: pointA.longitude + (hexagonSideLengh * sqrt(3) / 2)
        )
        
        let pointD = CLLocationCoordinate2D(
            latitude: pointA.latitude + hexagonSideLengh,
            longitude: pointA.longitude + (hexagonSideLengh * sqrt(3))
        )
        
        let pointE = CLLocationCoordinate2D(
            latitude: pointA.latitude,
            longitude: pointA.longitude + (hexagonSideLengh * sqrt(3))
        )
        
        let pointF = CLLocationCoordinate2D(
            latitude: pointA.latitude - (hexagonSideLengh / 2),
            longitude: pointA.longitude + (hexagonSideLengh * sqrt(3) / 2)
        )

        
        return NoFlyZonePolygon(
            geometrycType: .polygon,
            type: NoFlyZoneType.random(),
            coordinates: [pointA, pointB, pointC, pointD, pointE, pointF]
        )
    }

    func generateSimulatedNoFlyZoneCircle() -> NoFlyZoneCircle {
        let center = CLLocationCoordinate2D(
            latitude: Double.random(in: 43.4...48),
            longitude: Double.random(in: 20...31)
        )
        
        let radius: CLLocationDistance = Double.random(in: 10000...100000)
        
        return NoFlyZoneCircle(
            geometrycType: .circle,
            type: .random(),
            center: center,
            radius: radius
        )
    }
    
    func addNoFlyZoneShape(shape: NoFlyZoneShape) {
        
        let docRef = db.collection("airports").document()
        
        var data: [String: Any] = [
            "type": shape.geometrycType.rawValue,
            "zone-type": shape.type.rawValue,
        ]
        
        if shape.geometrycType == .circle {
            data["center"] = GeoPoint(
                latitude: (shape as! NoFlyZoneCircle).center.latitude,
                longitude: (shape as! NoFlyZoneCircle).center.longitude
            )
            data["radius"] = (shape as! NoFlyZoneCircle).radius
        } else if shape.geometrycType == .polygon {
            data["coordinates"] = (shape as! NoFlyZonePolygon).coordinates
                .map {
                    GeoPoint(
                        latitude: $0.latitude,
                        longitude: $0.longitude
                    )
                }
        }
        
        docRef.setData(data)
    }
}
