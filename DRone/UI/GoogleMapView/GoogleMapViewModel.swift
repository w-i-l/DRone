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
        
        currentLocationMarker.position = location
    }
}

class GoogleMapsViewModel: BaseViewModel {
    let map = GoogleMapsViewBridge()
    
    @Published var addressToFetchLocation: CLLocationCoordinate2D? = CLLocationCoordinate2D()
    @Published var searchingViewModel: SearchingViewModel = .init(adressToFetchLocation: .constant(CLLocationCoordinate2D()))
    
    override init() {
        super.init()
        
        var addressToFetchLocationBinding: Binding<CLLocationCoordinate2D?> = .init(get: {
            self.addressToFetchLocation
        }, set: { newValue in
            self.addressToFetchLocation = newValue
        })
        
        searchingViewModel = .init(
            adressToFetchLocation: addressToFetchLocationBinding,
            showCurrentLocation: false
        )
        
//        for _ in 0...50 {
//            FirebaseService.shared.addNoFlyZoneShape(shape: FirebaseService.shared.generateSimulatedNoFlyZoneCircle())
//        }
        
        FirebaseService.shared.fetchAllNoFlyZones()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] value in
                
                value.forEach {
                    switch $0.geometrycType {
                    case .circle:
                        self?.drawCircle(circle: $0 as! NoFlyZoneCircle )
                    case .polygon:
                        self?.drawPolygon(polygon: $0 as! NoFlyZonePolygon)
                    }
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
    
    func drawCircle(circle: NoFlyZoneCircle) {
        let circleToDraw = GMSCircle(
            position: circle.center,
            radius: circle.radius
        )
    
    
        
        var color: UIColor
        switch circle.type {
        case .firstZone:
            color = .yellow
        case .requestZone:
            color = .orange
        case .restricted:
            color = .red
        }
        circleToDraw.strokeWidth = 1
        circleToDraw.fillColor = color.withAlphaComponent(0.3)
        circleToDraw.strokeColor = color.withAlphaComponent(0.5)
        
        circleToDraw.map = self.map.mapView
    }
    
    func drawPolygon(polygon: NoFlyZonePolygon) {
        let path = GMSMutablePath()
        for coord in polygon.coordinates {
            path.add(coord)
        }
        path.add(polygon.coordinates.first!)
        
        let polygonToDraw = GMSPolygon(path: path)
        polygonToDraw.fillColor = UIColor.blue.withAlphaComponent(0.2) // Set the fill color and alpha
        polygonToDraw.strokeColor = UIColor.blue
        polygonToDraw.strokeWidth = 3.0
        
        polygonToDraw.map = self.map.mapView
    }


}
