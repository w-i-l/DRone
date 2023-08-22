//
//  GoogleMapViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 22.08.2023.
//

import SwiftUI
import Combine
import GoogleMaps


struct GoogleMapsViewBridge: UIViewRepresentable {
    
    private let zoom: Float = 15.0
    let mapView = GMSMapView.map(
        withFrame: CGRect.zero,
        camera: GMSCameraPosition(
            latitude: 44.54,
            longitude: 26.2,
            zoom: 10
        ))
    private let currentLocationMarker = GMSMarker()
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        if let location = LocationService.shared.locationManager.location?.coordinate {
            mapView.camera = GMSCameraPosition(
                target: location,
                zoom: 15
            )
            
            currentLocationMarker.position = location
            currentLocationMarker.title = "Your location"
            currentLocationMarker.map = mapView
            
            let imageView = UIImageView(image: UIImage(systemName: "mappin")?.withRenderingMode(.alwaysTemplate).withTintColor(.blue))
            imageView.tintColor = .blue
            currentLocationMarker.icon = imageView.image

        }
            return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        
    }
    
    func centerMapTo(location: CLLocationCoordinate2D) {
        mapView.camera = GMSCameraPosition (
            target: location,
            zoom: 15
        )
    }
}

class GoogleMapsViewModel: BaseViewModel {
    let map = GoogleMapsViewBridge()
    
    override init() {
        super.init()
        
        for _ in 0...200 {
            FirebaseService.shared.addNoFlyZone(
                coordinates: FirebaseService.shared.generateSimulatedNoFlyZone(),
                type: .poligon,
                zoneType: .firstZone
            )
        }
        
        FirebaseService.shared.fetchAllNoFlyZones()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] value in
                for coordinates in value {
                    self?.drawPolygon(coordinates: coordinates)
                }
            }
            .store(in: &bag)

    }
    
    func goToLocation(location: CLLocationCoordinate2D) {
        map.centerMapTo(location: location)
    }
    
    func goToCurrentLocation() {
        guard let location = LocationService.shared.locationManager.location?.coordinate else {
            return
        }
        
        goToLocation(location: location)
    }
    
    func changeTerrainType(type: String) {
        switch type {
        case "hybrid":
            map.mapView.mapType = .hybrid
        case "terrain":
            map.mapView.mapType = .terrain
        case "satellite":
            map.mapView.mapType = .satellite
        default:
            map.mapView.mapType = .hybrid
        }
    }
    
    func drawPolygon(coordinates: [CLLocationCoordinate2D]) {
        let path = GMSMutablePath()
        for coord in coordinates {
            path.add(coord)
        }
        path.add(coordinates.first!)
        
        let polygon = GMSPolygon(path: path)
        polygon.fillColor = UIColor.blue.withAlphaComponent(0.5) // Set the fill color and alpha
        polygon.strokeColor = UIColor.blue
        polygon.strokeWidth = 3.0
        
        let circle = GMSCircle(position: coordinates[2], radius: 1000)
        circle.fillColor = .red
        circle.map = self.map.mapView
        
        polygon.map = self.map.mapView
    }


}
