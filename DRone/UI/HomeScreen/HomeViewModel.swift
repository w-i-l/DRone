//
//  HomeViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 07.08.2023.
//

import SwiftUI
import CoreLocation


class HomeViewModel : BaseViewModel {
    
    @Published var fetchingState: FetchingState = .loading
    @Published var locationWeatherModel: LocationWeatherModel = .init(
        temperature: 0,
        sunset: "-",
        weatherStatus: "-",
        weatherIcon: "",
        precipitaionProbability: 0,
        windSpeed: 0,
        windDirection: "-",
        visibility: 0,
        satellites: Int.random(in: 0..<20),
        mainLocation: "",
        secondaryLocation: ""
    )
    @Published var weatherVerdict: (String, [Color]) = ("", [])
    @Published var addressToFetchLocation: CLLocationCoordinate2D?
    @Published var changeLocationViewModel: ChangeLocationViewModel = .init(adressToFetchLocation: .constant(CLLocationCoordinate2D()))
    
    var addressToFetchLocationBinding: Binding<CLLocationCoordinate2D?> = .init {
        CLLocationCoordinate2D()
    } set: { _ in
        
    }


    
    override init() {
        super.init()
        updateUI()
        
        AppService.shared.locationStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if value == .authorizedAlways || value == .authorizedWhenInUse {
                    self?.updateUI()
                }
            }
            .store(in: &bag)
       
        guard let location = LocationService.shared.locationManager.location?.coordinate else { return }
        self.addressToFetchLocation = location
        
        addressToFetchLocationBinding = .init(get: {
            self.addressToFetchLocation
        }, set: { newValue in
            self.addressToFetchLocation = newValue
        })
        
        self.changeLocationViewModel = .init(adressToFetchLocation: addressToFetchLocationBinding)
        
    }
    
    init(locationWeatherModel: LocationWeatherModel) {
        self.locationWeatherModel = locationWeatherModel
        self.fetchingState = .loaded
        
        super.init()
  
        AppService.shared.locationStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if value == .authorizedAlways || value == .authorizedWhenInUse {
                    self?.updateUI()
                }
            }
            .store(in: &bag)

        guard let location = LocationService.shared.locationManager.location?.coordinate else { return }
        self.addressToFetchLocation = location
        
        addressToFetchLocationBinding = .init(get: {
            self.addressToFetchLocation
        }, set: { newValue in
            self.addressToFetchLocation = newValue
        })
        
        self.changeLocationViewModel = .init(adressToFetchLocation: addressToFetchLocationBinding)
    }
    
    func updateUI() {
    
        self.fetchingState = .loading
        
        if let addressToFetchLocation {
            WeatherService.shared.getWeatherFor(location: addressToFetchLocation)
                .zip(LocationService.shared.getAdressForLocation(location: addressToFetchLocation))
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    
                } receiveValue: { [weak self] value in
                    self?.locationWeatherModel = value.0
                    self?.weatherVerdict = WeatherService.shared.getWeatherVerdict(locationWeatherModel: value.0)
                    self?.locationWeatherModel = LocationWeatherModel(
                        temperature: value.0.temperature,
                        sunset: value.0.sunset,
                        weatherStatus: value.0.weatherStatus,
                        weatherIcon: value.0.weatherIcon,
                        precipitaionProbability: value.0.precipitaionProbability,
                        windSpeed: value.0.windSpeed,
                        windDirection: value.0.windDirection,
                        visibility: value.0.visibility,
                        satellites: value.0.satellites,
                        mainLocation: value.1.mainAdress,
                        secondaryLocation: value.1.secondaryAdress
                    )
                    self?.fetchingState = .loaded
                }
                .store(in: &bag)
            
            return
        }
        
        if let location = LocationService.shared.locationManager.location?.coordinate{
            
            WeatherService.shared.getWeatherFor(location: location)
                .zip(LocationService.shared.getAdressForCurrentLocation())
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    
                } receiveValue: { [weak self] value in
                    self?.locationWeatherModel = value.0
                    self?.weatherVerdict = WeatherService.shared.getWeatherVerdict(locationWeatherModel: value.0)
                    self?.locationWeatherModel = LocationWeatherModel(
                        temperature: value.0.temperature,
                        sunset: value.0.sunset,
                        weatherStatus: value.0.weatherStatus,
                        weatherIcon: value.0.weatherIcon,
                        precipitaionProbability: value.0.precipitaionProbability,
                        windSpeed: value.0.windSpeed,
                        windDirection: value.0.windDirection,
                        visibility: value.0.visibility,
                        satellites: value.0.satellites,
                        mainLocation: value.1.mainAdress,
                        secondaryLocation: value.1.secondaryAdress
                    )
                    self?.fetchingState = .loaded
                }
                .store(in: &bag)
            self.addressToFetchLocation = nil
            
        } else {
            print("Failed to get location, location: \(String(describing: LocationService.shared.locationManager.location?.coordinate))")
        }
    }
    
}
