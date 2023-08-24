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
