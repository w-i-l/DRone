//
//  WeatherForecastViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 09.08.2023.
//

import Foundation
import CoreLocation

class WeatherForecastViewModel: BaseViewModel {
    
    @Published var weaTherWeekForecast = [LocationWeatherModel]()
    @Published var fetchingState: FetchingState = .loading
    
    let daysOfWeek: [String]
    let daysOfWeekDate: [String]
    
    var weatherURL: URL {
        if let location = LocationService.shared.locationManager.location?.coordinate {
            return URL(string: "https://weather.com/weather/today/l/\(location.latitude),\(location.longitude)?par=google")!
        }
        
        return URL(string: "https://weather.com/weather/today/l/44.45,26.07?par=google")!
    }
    
    init(location: CLLocationCoordinate2D) {
        
        let secondsInHour = 3600
        let secondsInDay = 24 * secondsInHour
        daysOfWeek = (0..<7)
            .map {
                
                let dateFormmater = DateFormatter()
                dateFormmater.dateFormat = "EEEE"
                
                return dateFormmater.string(from: Date() + TimeInterval(secondsInDay * $0))
            }
        
        daysOfWeekDate = (0..<7)
            .map {
                
                let dateFormmater = DateFormatter()
                dateFormmater.dateFormat = "dd MMMM"
                
                return dateFormmater.string(from: Date() + TimeInterval(secondsInDay * $0))
            }
        
        super.init()
        
//        guard let location = LocationService.shared.locationManager.location?.coordinate else { print("Can't get location"); return }
        WeatherService.shared.getWeatherForLocationWeekForecast(location: location)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] value in
                self?.weaTherWeekForecast = (0..<7)
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
