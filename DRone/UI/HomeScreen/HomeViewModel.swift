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
        weatherIcons: "",
        precipitaionProbability: 0,
        windSpeed: 0,
        windDirection: "-",
        visibility: 0,
        satellites: Int.random(in: 0..<20)
    )
    @Published var weatherVerdict: (String, [Color]) = ("", [])
    
    override init() {
        super.init()
        
        if let location = LocationService.shared.locationManager.location?.coordinate{
            print(location)
            WeatherService.shared.getWeatherFor(location: location)
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    
                } receiveValue: { [weak self] value in
                    self?.locationWeatherModel = value
                    self?.weatherVerdict = WeatherService.shared.getWeatherVerdict(locationWeatherModel: value)
                    self?.fetchingState = .loaded
                }
                .store(in: &bag)
        } else {
            print("Failed to get location, location: \(LocationService.shared.locationManager.location?.coordinate)")
        }

    }
    
}
