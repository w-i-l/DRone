//
//  WeatherService.swift
//  DRone
//
//  Created by Mihai Ocnaru on 07.08.2023.
//

import SwiftUI
import Combine
import CoreLocation

class WeatherService: BaseViewModel {
    static let shared = WeatherService()
    private var cachedCurrentLocationWeather: LocationWeatherModel?
    private var lastTimeCached: Date?
    
    private override init() {}
    
    func getWeatherFor(location: CLLocationCoordinate2D) -> AnyPublisher<LocationWeatherModel, Error> {
        WeatherAPI.shared.getWeatherFor(location: location)
           .eraseToAnyPublisher()
    }
    
    func getWeatherVerdict(locationWeatherModel: LocationWeatherModel) -> (String, [Color]) {
        if locationWeatherModel.precipitaionProbability <= 10 &&
            locationWeatherModel.satellites >= 12 &&
            locationWeatherModel.temperature >= 10 &&
            locationWeatherModel.visibility >= 5 &&
            locationWeatherModel.windSpeed <= 5 {
            return ("Good to fly", [.green, Color("green")])
        } else if locationWeatherModel.precipitaionProbability <= 40 &&
                    locationWeatherModel.satellites >= 6 &&
                    locationWeatherModel.temperature >= 5 &&
                    locationWeatherModel.visibility >= 3 &&
                    locationWeatherModel.windSpeed <= 10 {
                return ("Be careful", [.yellow, Color("green")])
        } else {
            return ("Can't take off", [.red, Color("red")])
        }
    }
}
