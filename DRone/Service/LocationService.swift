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
    
    private override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        GMSPlacesClient.provideAPIKey(LocationAPI.GOOGLE_PLACES_API_KEY)
        
    }
    
    func getAdressForCurrentLocation() -> AnyPublisher<(mainAdress: String, secondaryAdress: String), Error> {
        
        guard let location = locationManager.location?.coordinate else {
            print("No location! NO OUTPUT!")
            return Fail(error: NSError()).eraseToAnyPublisher()
            
        }
        
        return LocationAPI.shared.getAdressForCurrentLocation(location: location)
            .eraseToAnyPublisher()
        
    }
    
    func getAdressForLocation(location: CLLocationCoordinate2D) -> AnyPublisher<(mainAdress: String, secondaryAdress: String), Error> {

        return LocationAPI.shared.getAdressForCurrentLocation(location: location)
            .eraseToAnyPublisher()
        
    }
    
    func getAdressIDForCurrentLocation(location: CLLocationCoordinate2D) -> AnyPublisher<String, Error> {
        LocationAPI.shared.getAdressIDForCurrentLocation(location: location)
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
    
    func getPredictionsFromInput(textSearched: String) -> AnyPublisher<[(addressName: String, addressID: String)], Error> {
        LocationAPI.shared.getPredictionsFromInput(textSearched: textSearched)
            .eraseToAnyPublisher()
    }
    
    func getCoordinatesFromLocationID(ID: String) -> AnyPublisher<CLLocationCoordinate2D, Error> {
        LocationAPI.shared.getCoordinatesFromLocationID(ID: ID)
            .eraseToAnyPublisher()
    }
    
}
