import Foundation
import SwiftUI
import MapKit
import Combine
import GooglePlaces
import SwiftyJSON



class LocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    static let shared = LocationService()
    
    var locationManager = CLLocationManager()
    
    var mapCoordinates:CurrentValueSubject<MKCoordinateRegion, Never> = .init(MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 44.4353104,
            longitude: 26.113559
        ), span: MKCoordinateSpan(
            latitudeDelta: 0.1,
            longitudeDelta: 0.1
        )
    ))
    
    var bag = Set<AnyCancellable>()
    
    private var singleAddressCoordinatesCached: CLLocationCoordinate2D?
    private var singleAddressLocationCached: (mainAddress: String, secondaryAddress: String)?
    
    private override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        GMSPlacesClient.provideAPIKey(LocationAPI.GOOGLE_PLACES_API_KEY)
        
    }
    
    func getAddressForCurrentLocation() -> AnyPublisher<(mainAddress: String, secondaryAddress: String), Error> {
        
        guard let location = locationManager.location?.coordinate else {
            print("No location! NO OUTPUT!")
            return Fail(error: NSError()).eraseToAnyPublisher()
            
        }
        
        return self.getAddressForLocation(location: location)
        
    }
    
    func getAddressForLocation(location: CLLocationCoordinate2D) -> AnyPublisher<(mainAddress: String, secondaryAddress: String), Error> {

        if singleAddressCoordinatesCached == nil ||
            singleAddressCoordinatesCached != location {
            
            return Future<(mainAddress: String, secondaryAddress: String), Error> { [weak self] promise in
                LocationAPI.shared.getAddressForCurrentLocation(location: location)
                    .sink { _ in
                        
                    } receiveValue: { value in
                        self?.singleAddressCoordinatesCached = location
                        self?.singleAddressLocationCached = value
                        promise(.success(value))
                    }
                    .store(in: &self!.bag)
            }
            .eraseToAnyPublisher()
        } else {
            return Future<(mainAddress: String, secondaryAddress: String), Error> { [weak self] promise in
                promise(.success((self?.singleAddressLocationCached)!))
            }
            .eraseToAnyPublisher()
        }
        
    }
    
    func getAddressIDForCurrentLocation(location: CLLocationCoordinate2D) -> AnyPublisher<String, Error> {
        LocationAPI.shared.getAddressIDForCurrentLocation(location: location)
            .eraseToAnyPublisher()
    }
    
    func getCoordinatesFromLocationID(ID: String) -> AnyPublisher<CLLocationCoordinate2D, Error> {
        LocationAPI.shared.getCoordinatesFromLocationID(ID: ID)
            .eraseToAnyPublisher()
    }
    
    func getPredictionsFromInput(textSearched: String) -> AnyPublisher<[(addressName: String, addressID: String)], Error> {
        LocationAPI.shared.getPredictionsFromInput(textSearched: textSearched)
            .eraseToAnyPublisher()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        AppService.shared.locationStatus.value = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedAlways:
            break
        case .notDetermined:
            // need to ask
            manager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            break
        case .denied:
            // request to change from settings
//            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            break
        case .restricted:
            break
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func moveToCurentLocation() {
        if let location = self.locationManager.location {
            self.mapCoordinates.value.center = CLLocationCoordinate2D(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            self.mapCoordinates.value.span = MKCoordinateSpan(
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            )
        }
    }
}
