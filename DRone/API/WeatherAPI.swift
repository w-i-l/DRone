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
    
    private init() {}
    
    private func getWeatherImageFromWeatherCode(code: Int) -> (weatherIcon: String, weatherStatus: String) {
        
        if [95, 96, 99].contains(code) {
            return ("cloud.sun.bolt.fill", "Thunderstorm")
        } else if [1, 2, 3].contains(code) {
            return ("cloud.bolt.fill", "Storm")
        } else if [71, 73, 75, 77, 85, 86].contains(code) {
            return ("cloud.snow.fill", "Snowy")
        } else if [80, 81, 82, 61, 63, 65].contains(code) {
            return ("cloud.rain.fill", "Rainy")
        } else if [45, 48].contains(code) {
            return ("cloud.fog.fill", "Foggy")
        } else if [0].contains(code) {
            return ("sun.min.fill", "Sunny")
        } else {
            return ("cloud.fill", "Cloudy")
        }
    }
    
    /// Returns the string interpretation of degrees
    /// - Parameter windDirection: An int representing the degrees - N is consider to be 0º
    /// - Returns: A string description - N-NW
    private func getWindDirectionFromDegrees(windDirection: Int) -> String {
        if windDirection >= 0 && windDirection <= 18 {
            return "N"
        } else if windDirection <= 36 {
            return "N-NE"
        } else if windDirection <= 54 {
            return "NE"
        } else if windDirection <= 72 {
            return "E-NE"
        } else if windDirection <= 90 {
            return "E"
        } else if windDirection <= 108 {
            return "E-SE"
        } else if windDirection <= 144 {
            return "SE"
        } else if windDirection <= 162 {
            return "S-SE"
        } else if windDirection <= 180 {
            return "S"
        } else if windDirection <= 198 {
            return "S-SV"
        } else if windDirection <= 234 {
            return "SV"
        } else if windDirection <= 252 {
            return "V-SV"
        } else if windDirection <= 270 {
            return "V"
        } else if windDirection <= 288 {
            return "V-NV"
        } else if windDirection <= 324 {
            return "NV"
        } else if windDirection <= 342 {
           return "N-NV"
       } else {
           return "N"
       }
    }
    
    func getWeatherFor(location: CLLocationCoordinate2D) -> Future<LocationWeatherModel, Error> {
        Future<LocationWeatherModel, Error> { promise in
            
            
            var urlComponents = URLComponents(string: "https://api.open-meteo.com/v1/forecast")
            urlComponents?.queryItems = [
                URLQueryItem(name: "latitude", value: "\(location.latitude)"),
                URLQueryItem(name: "longitude", value: "\(location.longitude)"),
                URLQueryItem(name: "hourly", value: "temperature_2m,precipitation_probability,weathercode,visibility,windspeed_80m,winddirection_80m"),
                URLQueryItem(name: "daily", value: "sunset"),
                URLQueryItem(name: "timezone", value: "GMT"),
                URLQueryItem(name: "forecast_days", value: "1")
            ]
            
            var urlRequest = URLRequest(url: urlComponents!.url!)
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard error == nil else { return }
                guard let data else { return }
                
                do {
                    
                    let json = try JSON(data: data)
                    
                    // take the current date
                    let currentTime = Date()

                    // take only the hour and convert to local hour
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH"
                    dateFormatter.timeZone = TimeZone.current

                    // convert to take array index
                    // ex. 10:00:00 would be the 10th element in array
                    let formattedTime = dateFormatter.string(from: currentTime)
                    let arrayIndex = Int(formattedTime)
                    guard let arrayIndex else { promise(.failure(NSError(domain: "Can't convert String to Int", code: 2048))); return }
                    
                    // get the local sunset hour
                    let dateTimeString = json["daily"]["sunset"][0].stringValue
                    dateFormatter.dateFormat = "HH:MM"
                    let sunsetTime = dateFormatter.string(from: ISO8601DateFormatter().date(from: dateTimeString + ":00+0:00")!)
                    let hourMinutes = sunsetTime
                    
                    let weatherInfos = self.getWeatherImageFromWeatherCode(code: json["hourly"]["weathercode"][arrayIndex].intValue)
                    
                    let weather = LocationWeatherModel(
                        temperature: json["hourly"]["temperature_2m"][arrayIndex].intValue,
                        sunset: hourMinutes,
                        weatherStatus: weatherInfos.weatherStatus,
                        weatherIcon: weatherInfos.weatherIcon ,
                        precipitaionProbability: json["hourly"]["precipitation_probability"][arrayIndex].intValue,
                        windSpeed: json["hourly"]["windspeed_80m"][arrayIndex].intValue,
                        windDirection: self.getWindDirectionFromDegrees(windDirection: json["hourly"]["winddirection_80m"][arrayIndex].intValue),
                        visibility: Int(json["hourly"]["visibility"][arrayIndex].intValue / 1000),
                        satellites: Int.random(in: 0..<20),
                        mainLocation: "",
                        secondaryLocation: ""
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
