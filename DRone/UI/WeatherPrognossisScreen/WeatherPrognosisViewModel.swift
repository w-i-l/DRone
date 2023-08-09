//
//  WeatherPrognosisViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 09.08.2023.
//

import Foundation
import CoreLocation

class WeatherPrognosisViewModel: BaseViewModel {
    
    @Published var weaTherWeekPrognosis = [LocationWeatherModel]()
    @Published var fetchingState: FetchingState = .loading
    
    let daysOfWeek: [String]
    
    override init() {
        
        let secondsInHour = 3600
        let secondsInDay = 24 * secondsInHour
        daysOfWeek = (0..<7)
            .map {
                (Date.now + TimeInterval(secondsInDay * $0)).formatted(.dateTime.weekday(.wide))
            }
        
        super.init()
        
        guard let location = LocationService.shared.locationManager.location?.coordinate else { print("Can't get location"); return }
        WeatherService.shared.getWeatherForLocationWeekPrognosis(location: location)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] value in
                self?.weaTherWeekPrognosis = (0..<7)
                    .map {
                        let item = value[$0]
                        return LocationWeatherModel(
                            temperature: item.temperature,
                            sunset: item.sunset,
                            weatherStatus: item.weatherStatus,
                            weatherIcon: item.weatherIcon,
                            precipitaionProbability: item.precipitaionProbability,
                            windSpeed: item.windSpeed,
                            windDirection: item.windDirection,
                            visibility: item.visibility,
                            satellites: item.satellites,
                            mainLocation: self!.daysOfWeek[$0],
                            secondaryLocation: ""
                        )
                    }
                self?.fetchingState = .loaded
            }
            .store(in: &bag)
    }
    
    
}