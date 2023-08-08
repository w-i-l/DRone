import Foundation
import SwiftUI
import MapKit
import Combine
import GooglePlaces
import SwiftyJSON



class LocationService: NSObject, CLLocationManagerDelegate {
    
    static private let GOOGLE_PLACES_API_KEY = "AIzaSyDesWSxP-UzdOqphqUQTF42thMrm0nqyhI"
    static private let GOOGLE_GEO_API_KEY = "AIzaSyCYSsg0ZYwdf86R_7N3vW0O6A-D8y-4qpk"
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
        
        GMSPlacesClient.provideAPIKey(LocationService.GOOGLE_PLACES_API_KEY)
        
    }
    
    func getAdressForCurrentLocation() -> AnyPublisher<(mainAdress: String, secondaryAdress: String), Error> {
        
        Future<(mainAdress: String, secondaryAdress: String), Error> { [weak self] promise in
            guard let location = self?.locationManager.location?.coordinate else { promise(.failure(NSError())); return }
            
            var urlComponents = URLComponents(string: "https://maps.googleapis.com/maps/api/geocode/json")
            urlComponents?.queryItems = [
                URLQueryItem(name: "latlng", value: location.latitude.description + "," + location.longitude.description),
                URLQueryItem(name: "key", value: LocationService.GOOGLE_GEO_API_KEY)
            ]
            
            var urlRequest = URLRequest(url: urlComponents!.url!)
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard error == nil && data != nil else { promise(.failure(NSError())); return }
                
                do{
                    let json = try JSON(data: data!)
                    
                    // get the first array
                    let adressComponents = json["results"][0]["address_components"].arrayValue
                    
                    // fetching for the format City, COUNTRY
                    let cityName = adressComponents.first { $0["types"].arrayValue.contains("administrative_area_level_1")}!["long_name"].stringValue
                    let shortCountry = adressComponents.first { $0["types"].arrayValue.contains("country")}!["short_name"].stringValue
                    
                    // for some location we can't fetch the street
                    if let street = adressComponents.first { $0["types"].arrayValue.contains("route")}{
                        if let streetNumber = adressComponents.first { $0["types"].arrayValue.contains("street_number")}{
                            promise(.success((
                                mainAdress: cityName + ", " + shortCountry,
                                secondaryAdress: street["long_name"].stringValue + ", " + streetNumber["long_name"].stringValue
                            )))
                            return
                        }
                    }
                    
                    // we return this when we can't fetch street
                    promise(.success((
                        mainAdress: cityName + ", " + shortCountry,
                        secondaryAdress: "No street"
                    )))
                    
                } catch (let error) {
                    promise(.failure(error))
                }
            }
            
            dataTask.resume()
        }
        .eraseToAnyPublisher()
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
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
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
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
