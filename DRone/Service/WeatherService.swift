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

    private var singleLocationCachedCurrentLocationWeather: LocationWeatherModel?
    private var singleLocationLastTimeCached: Date? = nil

    private var weeklyForecastLocationsCached: [LocationWeatherModel]?
    private var weeklyForecastLastTimeCached: Date?
    
    private override init() {}
    
    func getWeatherFor(location: CLLocationCoordinate2D) -> AnyPublisher<LocationWeatherModel, Error> {
        
        // if we cached in past
        // or if it passes 1h mark
        // or we're asked for other location
        if singleLocationLastTimeCached == nil ||
            singleLocationCachedCurrentLocationWeather == nil ||
            Date().timeIntervalSince(singleLocationLastTimeCached!) >= 3600 ||
            singleLocationCachedCurrentLocationWeather?.coordinates != location
        {
              
            return Future<LocationWeatherModel, Error> { [weak self] promise in
                WeatherAPI.shared.getWeatherFor(location: location)
                    .sink(receiveCompletion: { _ in
                        
                    }, receiveValue: { value in

                        self?.singleLocationLastTimeCached = Date()
                        self?.singleLocationCachedCurrentLocationWeather = value
                        promise(.success(value))
                    })
                    .store(in: &self!.bag)
            }
            .eraseToAnyPublisher()

        } else {
            
            return Future<LocationWeatherModel, Error> { [weak self] promise in
                promise(.success((self?.singleLocationCachedCurrentLocationWeather)!))
            }
            .eraseToAnyPublisher()
        }
    }
    
    func getWeatherForLocationWeekForecast(location: CLLocationCoordinate2D) -> AnyPublisher<[LocationWeatherModel], Error> {
        
        if weeklyForecastLocationsCached == nil ||
            weeklyForecastLastTimeCached == nil ||
            Date().timeIntervalSince(weeklyForecastLastTimeCached!) >= 3600 ||
            weeklyForecastLocationsCached!.first!.coordinates != location {
            
            return Future<[LocationWeatherModel], Error> { [weak self] promise in
                
                WeatherAPI.shared.getWeatherForLocationWeekForecast(location: location)
                    .sink { _ in
                        
                    } receiveValue: { value in
                        self?.weeklyForecastLastTimeCached = Date()
                        self?.weeklyForecastLocationsCached = value
                        promise(.success(value))
                    }
                    .store(in: &self!.bag)

            }
                .eraseToAnyPublisher()
        } else {
            return Future<[LocationWeatherModel], Error> { [weak self] promise in
                promise(.success((self?.weeklyForecastLocationsCached)!))
            }
            .eraseToAnyPublisher()
        }
    }
    
    let precipitationProbabilityIdealCondition: Int = 10
    let precipitationProbabilityGoodCondition: Int = 40
    
    let satellitesIdealCondition:Int = 12
    let satellitesGoodContion: Int = 6
    
    let temperatureIdealCondition:Int = 10
    let temperatureGoodContion: Int = 0
    
    let visibilityIdealCondition:Int = 20
    let visibilityGoodContion: Int = 10
    
    let windSpeedIdealCondition:Int = 15
    let windSpeedGoodCondition:Int = 20
    
    func getWeatherVerdict(locationWeatherModel: LocationWeatherModel) -> (String, [Color]) {
        if locationWeatherModel.precipitationProbability <= precipitationProbabilityIdealCondition &&
            locationWeatherModel.satellites >= satellitesIdealCondition &&
            locationWeatherModel.temperature >= temperatureIdealCondition &&
            locationWeatherModel.visibility >= visibilityIdealCondition &&
            locationWeatherModel.windSpeed <= windSpeedIdealCondition {
            return ("Good to fly", [.green, Color("green")])
        } else if locationWeatherModel.precipitationProbability <= precipitationProbabilityGoodCondition &&
                    locationWeatherModel.satellites >= satellitesGoodContion &&
                    locationWeatherModel.temperature >= temperatureGoodContion &&
                    locationWeatherModel.visibility >= visibilityGoodContion &&
                    locationWeatherModel.windSpeed <= windSpeedGoodCondition {
            return ("Be careful", [.yellow, Color("yellow")])
        } else {
            return ("Can't take off", [Color("red"), .red])
        
            
        }
    }
}
