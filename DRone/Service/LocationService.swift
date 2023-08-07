import Foundation
import SwiftUI
import MapKit
import Combine



class LocationService: NSObject, CLLocationManagerDelegate {
   
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
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            break
        case .notDetermined:
            // need to ask
            manager.requestWhenInUseAuthorization()
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
