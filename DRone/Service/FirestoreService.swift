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
import FirebaseAuth

class FirebaseService: BaseViewModel {
    
    static let shared: FirebaseService = .init()
    let db = Firestore.firestore()
    
    var indexOfModifiedFlightRequest: CurrentValueSubject<Int, Never> = .init(0)
    var allFlightsRequests: CurrentValueSubject<[RequestFormModel], Never> = .init([])
    
    private var isCollectionListened: Bool = false
    private var listenerRegistration: ListenerRegistration
    
    override private init() {
    
        listenerRegistration = db.collection("users")
        .addSnapshotListener { _, _ in
                        
        }

        super.init()
    }
    
    func removeListener() {
        listenerRegistration.remove()
        isCollectionListened = false
    }
    
    func deleteFlyRequest(ID: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(uid).collection("fly-requests").getDocuments { querrySnapshot, error in
            guard error == nil else { print(error!.localizedDescription); return }
            guard let querrySnapshot else { return }
            
            if let document = querrySnapshot.documents.first(where: { ($0["ID"] as! String) == ID }) {
                self.db.collection("users").document(uid).collection("fly-requests").document(document.documentID).delete { error in
                    if error == nil {
                        self.allFlightsRequests.value.removeAll {
                            $0.responseModel.ID == ID
                        }
                    }
                }
            }
        }
    }
    
    func listenToFlightRequest(user uid: String) {
       
        guard self.isCollectionListened == false else {
            print("Already listened")
            return
        }
        
        self.isCollectionListened = true
        self.listenerRegistration = db.collection("users").document(uid).collection("fly-requests").addSnapshotListener { querrySnapshot, error in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let documents = querrySnapshot?.documents else {
                print("Error fetching documents \(error!.localizedDescription)")
                return
            }
            

            
            querrySnapshot?.documentChanges.forEach({ [weak self] diff in
                switch diff.type {
                case .added:
                    break
                case .modified:
                    let updatedFlightRequest = diff.document.data()
                    self?.indexOfModifiedFlightRequest.value = (self?.allFlightsRequests.value.firstIndex { $0.responseModel.ID == updatedFlightRequest["ID"] as! String}!)!
                    let response = ResponseResult.match(response: updatedFlightRequest["response"] as! String)
                    let ID = updatedFlightRequest["ID"] as! String
                    self?.allFlightsRequests.value[self!.indexOfModifiedFlightRequest.value].responseModel.response = response
                    NotificationService.shared.postNotification(
                        title: "Flight \(response.rawValue.lowercased())",
                        subtitle: "Your flight with ID: \(ID) was \(response.rawValue.lowercased()). Tap to see more!"
                    )
                    
                case .removed:
                    break
                }
            })
        }
    }
    
    func fetchFlightRequestsForCurrentUser() {
        
        AppService.shared.user
            .sink { [weak self] value in
                if let value {
                    self?.fetchFlightRequestsFor(user: value.uid)
                        .receive(on: DispatchQueue.main)
                        .sink(receiveCompletion: { _ in
                            
                        }, receiveValue: { flights in
                            self?.allFlightsRequests.value = flights
                            self?.listenToFlightRequest(user: value.uid)
                        })
                        .store(in: &self!.bag)
                }
            }
            .store(in: &bag)
            
        }
    
    func fetchFlightRequestsFor(user uid: String) -> Future<[RequestFormModel], Error> {
        Future<[RequestFormModel], Error> { [weak self] promise in
            
            var arrayToReturn: [RequestFormModel] = []
            
            self?.db.collection("users").document(uid).collection("fly-requests").getDocuments(completion: { (querySnapshot, error) in
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
                        flightAddress: (
                            mainAddress: data["flight-address-secondary"] as! String,
                            secondaryAddress: data["flight-address-main"] as! String
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
    
    func postFlightRequestFor(user uid: String, formModel: RequestFormModel) {
        
        let docRef = db.collection("users").document(uid).collection("fly-requests").document()
        
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
            "flight-address-main": formModel.flightAddress.mainAddress,
            "flight-address-secondary": formModel.flightAddress.secondaryAddress,
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
            
            self?.db.collection("no-fly-zones").getDocuments(completion: { querrySnapshot, error in
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
    
    func generateSimulatedNoFlyZonePolygon(latitudeRange: ClosedRange<Double> = -90...90, longitudeRange: ClosedRange<Double> = -180...180) -> NoFlyZonePolygon {

        // we draw an hexagon with points
        /*
            E   D
         F         C
            A   B
         */
        
        let hexagonSideLengh: Double = Double.random(in: 0.1...0.4)
        let pointA = CLLocationCoordinate2D(
            latitude: Double.random(in: latitudeRange),
            longitude: Double.random(in: longitudeRange)
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

    func generateSimulatedNoFlyZoneCircle(latitudeRange: ClosedRange<Double> = -90...90, longitudeRange: ClosedRange<Double> = -180...180) -> NoFlyZoneCircle {
        let center = CLLocationCoordinate2D(
            latitude: Double.random(in: latitudeRange),
            longitude: Double.random(in: longitudeRange)
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
        
        let docRef = db.collection("no-fly-zones").document()
        
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


enum LoginState: String, CaseIterable {
    case notLoggedIn = "notLoggedIn"
    case loggedIn = "loggedIn"
    case authentificated = "authentificated"
    case emailNotVerified = "emailNotVerified"
    case alreadyExistsUser = "alreadyExistsUser"
    case wrongPassword = "wrongPassword"
    case error = "error"
    case tooManyRequests = "tooManyRequests"
    case noUserFound = "noUserFound"
    
    static func match(loginState: String) -> LoginState {
        for state in LoginState.allCases {
            if state.rawValue == loginState {
                return state
            }
        }
        
        return .notLoggedIn
    }
}

// login and auth
extension FirebaseService{
    
    func auth(email: String, password: String) -> Future<LoginState, Never> {
        
        Future<LoginState, Never> { promise in
            
            Auth.auth().createUser(
                withEmail: email,
                password: password
            ) { result, error in
                
                if let nsError = error as? NSError {
                    
                    let authError = AuthErrorCode(_nsError: nsError)
                    
                    switch authError.code {
                    case .emailAlreadyInUse :
                        print("email exists")
                        promise(.success(.alreadyExistsUser))
                    default:
                        print(error!.localizedDescription)
                        promise(.success(.error))
                    }
                }
                
                guard result != nil else {
                    promise(.success(.error))
                    return
                }
                
                promise(.success(.authentificated))
            }
        }
    }
    
    func saveUserInfoToFirestore(firstName: String, lastName: String, CNP: String, email: String) {
        
        if let user = Auth.auth().currentUser {
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "first-name": firstName,
                "last-name": lastName,
                "CNP": CNP,
                "email": email
            ]

            db.collection("users").document(user.uid).collection("info").document("user-data").setData(userData) { error in
                if let error = error {
                    print("Error saving user data: \(error.localizedDescription)")
                } else {
                    print("User data saved successfully.")
                }
            }
        }
    }
    
    func login(email: String, password: String) -> Future<LoginState, Never> {
        
        Future<LoginState, Never> { promise in
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
                
                if let nsError = error as? NSError {
                    
                    let authError = AuthErrorCode(_nsError: nsError)
                    
                    switch authError.code {
                    case .wrongPassword :
                        print("wrong password")
                        promise(.success(.wrongPassword))
                    case .tooManyRequests:
                        print("too many wrong requests")
                        promise(.success(.tooManyRequests))
                    case .userNotFound:
                        print("no user found")
                        promise(.success(.noUserFound))
                    default:
                        print(error!.localizedDescription)
                        promise(.success(.error))
                    }
                }
                
                guard let result else {
                    print(error!.localizedDescription)
                    return
                    
                }
                
                print(result.user.isEmailVerified)
                if !result.user.isEmailVerified {
                    promise(.success(.emailNotVerified))
                    result.user.sendEmailVerification()
                } else {
                    promise(.success(.loggedIn))
                }
                
            }
        }
    }
    
    func verifyEmailExists(email: String) -> Future<Bool, Never> {
        Future<Bool, Never> { promise in
            Auth.auth().fetchSignInMethods(forEmail: email, completion: { (providers, error) in

                    if let error = error {
                        print(error.localizedDescription)
                    } else if let providers = providers {
                        print(providers)
                        promise(.success(true))
                    }
                
                promise(.success(false))
                })
        }
    }
    
    func getUserWithInfo() -> Future<User?, Never> {
        Future<User?, Never> { promise in
            if let user = Auth.auth().currentUser {
                let db = Firestore.firestore()
                let docRef = db.collection("users").document(user.uid).collection("info").document("user-data")
                
                docRef.getDocument { document, error in
                    if let document = document, document.exists {
                        let data = document.data()!
                        let firstName = data["first-name"] as! String
                        let lastName = data["last-name"] as! String
                        let CNP = data["CNP"] as! String
                        let email = data["email"] as! String
                        
                        promise(.success(User(
                            uid: user.uid,
                            email: email,
                            firstName: firstName,
                            lastName: lastName,
                            CNP: CNP
                        )))
                        
                    } else {
                        print("Document does not exist")
                    }
                }
            } else if let userUID = UserDefaults.standard.object(forKey: "userUID") as? String{
                let db = Firestore.firestore()
                let docRef = db.collection("users").document(userUID).collection("info").document("user-data")
                
                docRef.getDocument { document, error in
                    if let document = document, document.exists {
                        let data = document.data()!
                        let firstName = data["first-name"] as! String
                        let lastName = data["last-name"] as! String
                        let CNP = data["CNP"] as! String
                        let email = data["email"] as! String
                        
                        promise(.success(User(
                            uid: userUID,
                            email: email,
                            firstName: firstName,
                            lastName: lastName,
                            CNP: CNP
                        )))
                    }
                }
            } else {
                
                promise(.success(nil))
            }
        }
    }
}
