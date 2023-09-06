//
//  GoogleMapViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 22.08.2023.
//

import SwiftUI
import Combine
import GoogleMaps
import BottomSheet


struct GoogleMapsViewBridge: UIViewRepresentable {
    
    let delegate = GoogleMapsDelegate()
    
    private let zoom: Float = 15.0
    let mapView = GMSMapView.map(
        withFrame: CGRect.zero,
        camera: GMSCameraPosition(
            latitude: 44.54,
            longitude: 26.2,
            zoom: 10
        ))
    private let currentLocationMarker = GMSMarker()
    
    var rectangleToRenderCoordinates: (
        north: CLLocationCoordinate2D,
        est: CLLocationCoordinate2D,
        south: CLLocationCoordinate2D,
        west: CLLocationCoordinate2D
    ) = (
        CLLocationCoordinate2D(),
        CLLocationCoordinate2D(),
        CLLocationCoordinate2D(),
        CLLocationCoordinate2D()
    )
    
    var rectangleToRender = GMSPolygon()
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        if let location = LocationService.shared.locationManager.location?.coordinate {
            mapView.camera = GMSCameraPosition(
                target: location,
                zoom: 10
            )
            
            mapView.isMyLocationEnabled = true
            mapView.setMinZoom(5, maxZoom: 20)
            
            let imageView = UIImageView(image: UIImage(systemName: "mappin")?.withRenderingMode(.alwaysTemplate).withTintColor(.blue))
            imageView.tintColor = .blue
            currentLocationMarker.icon = imageView.image

        }
        
        // drawing the frame to show
        let path = GMSMutablePath()
        path.add(rectangleToRenderCoordinates.north)
        path.add(rectangleToRenderCoordinates.est)
        path.add(rectangleToRenderCoordinates.south)
        path.add(rectangleToRenderCoordinates.west)
        path.add(rectangleToRenderCoordinates.north)
        
        rectangleToRender.path = path
//        polygonToDraw.fillColor = UIColor.purple.withAlphaComponent(0.2) // Set the fill color and alpha
//        rectangleToRender.strokeColor = UIColor.purple
//        rectangleToRender.strokeWidth = 3.0
        rectangleToRender.fillColor = .none
        
        rectangleToRender.map = self.mapView
        
        
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
    }
    
    func centerMapTo(location: CLLocationCoordinate2D) {
        mapView.camera = GMSCameraPosition (
            target: location,
            zoom: 10
        )
        
        currentLocationMarker.position = location
    }
}

class GoogleMapsViewModel: BaseViewModel {
    var map = GoogleMapsViewBridge()
    
    @Published var addressToFetchLocation: CLLocationCoordinate2D? = CLLocationCoordinate2D()
    @Published var searchingViewModel: SearchingViewModel = .init(addressToFetchLocation: .constant(CLLocationCoordinate2D()))
    @Published var bottomSheetPosition: BottomSheetPosition = .hidden
    
    private var numberOfCircles: Int = 30
    
    var noFlyZonesRendered: [GMSCircle] = []
    
    override init() {
        super.init()
        
        self.map.mapView.delegate = self.map.delegate
        self.map.delegate.parent = self
        
        let addressToFetchLocationBinding: Binding<CLLocationCoordinate2D?> = .init(get: {
            self.addressToFetchLocation
        }, set: { newValue in
            self.addressToFetchLocation = newValue
        })
        
        searchingViewModel = .init(
            addressToFetchLocation: addressToFetchLocationBinding,
            showCurrentLocation: false
        )
        
//        for _ in 0...300 {
//            FirebaseService.shared.addNoFlyZoneShape(shape: FirebaseService.shared.generateSimulatedNoFlyZoneCircle())
//            FirebaseService.shared.addNoFlyZoneShape(shape: FirebaseService.shared.generateSimulatedNoFlyZonePolygon())
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
        
        AppService.shared.locationStatus
            .receive(on: DispatchQueue.main)
            .sink { value in
                if value == .authorizedAlways || value == .authorizedWhenInUse {
                    self.map.mapView.isMyLocationEnabled = true
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
    
        noFlyZonesRendered.append(circleToDraw)
        
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

    func renderNoFlyZonesGeneratedForLocation(northEst: CLLocationCoordinate2D, southWest: CLLocationCoordinate2D) {
        
        clearRenderedNoFlyZones()
        
        for _ in 0...self.numberOfCircles {
            
            let circle = FirebaseService.shared.generateSimulatedNoFlyZoneCircle(
                latitudeRange: southWest.latitude...northEst.latitude,
                longitudeRange: southWest.longitude...northEst.longitude
            )
            
            drawCircle(circle: circle)
        }
    }
    
    func clearRenderedNoFlyZones() {
        for i in 0..<noFlyZonesRendered.count {
            noFlyZonesRendered[i].map = nil
        }
    }

}


class GoogleMapsDelegate: NSObject, GMSMapViewDelegate {

    weak var parent: GoogleMapsViewModel?
    
    
    func drawRenderedRectangle(_ mapView: GMSMapView) {
    

        let center = mapView.camera.target
        
        let scale: Double = 5
        
        parent?.map.rectangleToRenderCoordinates.north = CLLocationCoordinate2D(
            latitude: center.latitude + scale,
            longitude: center.longitude + scale
        )
        
        parent?.map.rectangleToRenderCoordinates.est = CLLocationCoordinate2D(
            latitude: center.latitude + scale,
            longitude: center.longitude - scale
        )
    
        
        parent?.map.rectangleToRenderCoordinates.south = CLLocationCoordinate2D(
            latitude: center.latitude - scale,
            longitude: center.longitude - scale
        )
        
        
        parent?.map.rectangleToRenderCoordinates.west = CLLocationCoordinate2D(
            latitude: center.latitude - scale,
            longitude: center.longitude + scale
        )
        
        let path = GMSMutablePath()
        path.add((parent?.map.rectangleToRenderCoordinates.north)!)
        path.add((parent?.map.rectangleToRenderCoordinates.est)!)
        path.add((parent?.map.rectangleToRenderCoordinates.south)!)
        path.add((parent?.map.rectangleToRenderCoordinates.west)!)
        path.add((parent?.map.rectangleToRenderCoordinates.north)!)
        
        parent?.map.rectangleToRender.path = path
        parent?.map.rectangleToRender.map = mapView
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        
        let center = mapView.camera.target
        
        if (!(center.latitude <= (self.parent?.map.rectangleToRenderCoordinates.north.latitude)! &&
             center.latitude >= (self.parent?.map.rectangleToRenderCoordinates.south.latitude)! &&
             center.longitude <= (self.parent?.map.rectangleToRenderCoordinates.west.longitude)! &&
             center.longitude >= (self.parent?.map.rectangleToRenderCoordinates.est.longitude)!)) {
            
            drawRenderedRectangle(mapView)
            
            parent?.renderNoFlyZonesGeneratedForLocation(
                northEst: CLLocationCoordinate2D(
                    latitude: (self.parent?.map.rectangleToRenderCoordinates.north.latitude)!,
                    longitude: (self.parent?.map.rectangleToRenderCoordinates.north.longitude)!
                ) ,
                southWest: CLLocationCoordinate2D(
                    latitude: (self.parent?.map.rectangleToRenderCoordinates.south.latitude)!,
                    longitude: (self.parent?.map.rectangleToRenderCoordinates.south.longitude)!
                )
            )
        }
        
        if abs((parent?.searchingViewModel.addressToFetchLocation!.latitude)! - center.latitude) > 2 ||
            abs((parent?.searchingViewModel.addressToFetchLocation!.longitude)! - center.longitude) > 3 {
            parent?.searchingViewModel.textSearched = ""
        }
    }
}
