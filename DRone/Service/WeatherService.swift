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
    //    private lazy var cachedCurrentLocationWeather = ReactiveData { [weak self] in
    //        WeatherAPI.shared.getWeatherFor(location: LocationService.shared.locationManager.location!.coordinate)
    //            .eraseToAnyPublisher()
    //    }
    private var cachedCurrentLocationWeather: LocationWeatherModel?
    private var lastTimeCached: Date? = nil
    private var isFetching: Bool = false
    
    private override init() {}
    
    func getWeatherFor(location: CLLocationCoordinate2D) -> AnyPublisher<LocationWeatherModel, Error> {
        
        // if we cached in past
        // and if it passes 1h mark
        if lastTimeCached == nil ||
            cachedCurrentLocationWeather == nil ||
            Date().timeIntervalSince(lastTimeCached!) >= 1 {
            
            //caching
            lastTimeCached = Date()
            
            if !isFetching {
                WeatherAPI.shared.getWeatherFor(location: location)
                    .sink(receiveCompletion: { _ in
                        
                    }, receiveValue: { value in
                        self.cachedCurrentLocationWeather = value
                    })
                    .store(in: &bag)
                
                isFetching.toggle()
            }
            
            // we fecth the data again
            return WeatherAPI.shared.getWeatherFor(location: location)
                .eraseToAnyPublisher()
        } else {
            
            //caching
            lastTimeCached = Date()
            
            return Future<LocationWeatherModel, Error> { [weak self] promise in
                promise(.success((self?.cachedCurrentLocationWeather)!))
            }
            .eraseToAnyPublisher()
        }
        
        //        cachedCurrentLocationWeather.getPublisher()
    }
    
    func getWeatherForLocationWeekForecast(location: CLLocationCoordinate2D) -> AnyPublisher<[LocationWeatherModel], Error> {
        WeatherAPI.shared.getWeatherForLocationWeekForecast(location: location)
            .eraseToAnyPublisher()
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
            return ("Can't take off", [.red, Color("red")])
        
            
        }
    }
}
