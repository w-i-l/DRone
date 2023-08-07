//
//  WeatherAPI.swift
//  DRone
//
//  Created by Mihai Ocnaru on 07.08.2023.
//

import SwiftUI
import Combine
import CoreLocation
import SwiftyJSON

class WeatherAPI {
    static let shared = WeatherAPI()
    private static let API_KEY = "0988226c472748f6bee1cb49c9424b6d"
    
    private init() {}
    
    private func getWeatherImageFromWeatherCode(code: Int) -> String {
        guard code >= 200 else { return "xmark" }
        
        if code <= 202 {
            return "cloud.sun.bolt.fill"
        } else if code <= 300 {
            return "cloud.bolt.fill"
        } else if code <= 500 {
            return "cloud.snow.fill"
        } else if code <= 623 {
            return "cloud.rain.fill"
        } else if code < 800 {
            return "cloud.fog.fill"
        } else if code == 800 {
            return "sun.min.fill"
        } else {
            return "cloud.fill"
        }
    }
    
    func getWeatherFor(location: CLLocationCoordinate2D) -> Future<LocationWeatherModel, Error> {
        Future<LocationWeatherModel, Error> { promise in
            
            
            var urlComponents = URLComponents(string: "https://api.weatherbit.io/v2.0/current")
            urlComponents?.queryItems = [
                URLQueryItem(name: "key", value: WeatherAPI.API_KEY),
                URLQueryItem(name: "lat", value: "\(location.latitude)"),
                URLQueryItem(name: "lon", value: "\(location.longitude)")
            ]
            
            var urlRequest = URLRequest(url: urlComponents!.url!)
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard error == nil else { return }
                guard let data else { return }
                
                do {
                    let json = try JSON(data: data)["data"][0]
                    
                    let weather = LocationWeatherModel(
                        temperature: json["app_temp"].intValue,
                        sunset: json["sunset"].stringValue,
                        weatherStatus: json["weather"]["description"].stringValue,
                        weatherIcons: self.getWeatherImageFromWeatherCode(code: json["weather"]["code"].intValue),
                        precipitaionProbability: json["precip"].intValue,
                        windSpeed: json["wind_spd"].intValue,
                        windDirection: json["wind_cdir"].stringValue,
                        visibility: json["vis"].intValue,
                        satellites: Int.random(in: 0..<20)
                    )
                    promise(.success(weather))
                    
                } catch(let error) {
                    print(error)
                    promise(.failure(error))
                }
                
            }
            
            dataTask.resume()
        }
    }
}
