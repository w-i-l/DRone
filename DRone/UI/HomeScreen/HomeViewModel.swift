//
//  HomeViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 07.08.2023.
//

import SwiftUI
import CoreLocation
import BottomSheet


class HomeViewModel : BaseViewModel {
    
    @Published var fetchingState: FetchingState = .loading
    @Published var locationWeatherModel: LocationWeatherModel = .init(
        temperature: 0,
        sunset: "-",
        weatherStatus: "-",
        weatherIcon: "",
        precipitationProbability: 0,
        windSpeed: 0,
        windDirection: "-",
        visibility: 0,
        satellites: Int.random(in: 0..<20),
        mainLocation: "",
        secondaryLocation: "",
        coordinates: CLLocationCoordinate2D()
    )
    @Published var weatherVerdict: (String, [Color]) = ("", [])
    @Published var addressToFetchLocation: CLLocationCoordinate2D?
    @Published var changeLocationViewModel: ChangeLocationViewModel = .init(addressToFetchLocation: .constant(CLLocationCoordinate2D()))
    
    @Published var shouldDisplayLocationToast: Bool = false

    let isShowingAsChild: Bool
    
    var addressToFetchLocationBinding: Binding<CLLocationCoordinate2D?> = .init {
        CLLocationCoordinate2D()
    } set: { _ in
        
    }

    var weatherURL: URL {
        if let location = LocationService.shared.locationManager.location?.coordinate {
            return URL(string: "https://weather.com/weather/today/l/\(location.latitude),\(location.longitude)?par=google")!
        }
        
        return URL(string: "https://weather.com/weather/today/l/44.45,26.07?par=google")!
    }
    
    init(isShowingAsChild: Bool) {
        self.isShowingAsChild = isShowingAsChild
        self.addressToFetchLocation = CLLocationCoordinate2D()
        super.init()
        updateUI()
        
        AppService.shared.locationStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if value == .authorizedAlways || value == .authorizedWhenInUse {
                    self?.updateUI()
                } else {
                    AppService.shared.isTabBarVisible.value = false
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
        
        self.changeLocationViewModel = .init(addressToFetchLocation: addressToFetchLocationBinding)
        
    }
    
    init(locationWeatherModel: LocationWeatherModel, isShowingAsChild: Bool) {
        self.locationWeatherModel = locationWeatherModel
        self.fetchingState = .loaded
        
        self.isShowingAsChild = isShowingAsChild
        self.addressToFetchLocation = CLLocationCoordinate2D()
        
        super.init()
  
        AppService.shared.locationStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if value == .authorizedAlways || value == .authorizedWhenInUse {
                    if self?.isShowingAsChild == false {
                        self?.updateUI()
                        AppService.shared.isTabBarVisible.value = true
                    } else {
                        self?.weatherVerdict = WeatherService.shared.getWeatherVerdict(locationWeatherModel: self!.locationWeatherModel)
                    }
                } else {
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
        
        self.changeLocationViewModel = .init(addressToFetchLocation: addressToFetchLocationBinding)
    }
    
    func updateUI() {
    
        self.fetchingState = .loading
        
        if let addressToFetchLocation, addressToFetchLocation != CLLocationCoordinate2D() {
            WeatherService.shared.getWeatherFor(location: addressToFetchLocation)
                .zip(LocationService.shared.getAddressForLocation(location: addressToFetchLocation))
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
                        precipitationProbability: value.0.precipitationProbability,
                        windSpeed: value.0.windSpeed,
                        windDirection: value.0.windDirection,
                        visibility: value.0.visibility,
                        satellites: value.0.satellites,
                        mainLocation: value.1.mainAddress,
                        secondaryLocation: value.1.secondaryAddress,
                        coordinates: addressToFetchLocation
                    )
                    self?.fetchingState = .loaded
                }
                .store(in: &bag)
            
            return
        }
        
        if let location = LocationService.shared.locationManager.location?.coordinate{
            
            WeatherService.shared.getWeatherFor(location: location)
                .zip(LocationService.shared.getAddressForCurrentLocation())
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
                        precipitationProbability: value.0.precipitationProbability,
                        windSpeed: value.0.windSpeed,
                        windDirection: value.0.windDirection,
                        visibility: value.0.visibility,
                        satellites: value.0.satellites,
                        mainLocation: value.1.mainAddress,
                        secondaryLocation: value.1.secondaryAddress,
                        coordinates: location
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
