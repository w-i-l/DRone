//
//  LocationAPI.swift
//  DRone
//
//  Created by Mihai Ocnaru on 09.08.2023.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation
import SwiftyJSON

class LocationAPI {
    
    static let GOOGLE_PLACES_API_KEY = "AIzaSyDesWSxP-UzdOqphqUQTF42thMrm0nqyhI"
    static let GOOGLE_GEO_API_KEY = "AIzaSyCYSsg0ZYwdf86R_7N3vW0O6A-D8y-4qpk"
    
    static let shared = LocationAPI()
    
    private init() {}
    
    func getAdressForCurrentLocation(location: CLLocationCoordinate2D) -> Future<(mainAdress: String, secondaryAdress: String), Error> {
        
        Future<(mainAdress: String, secondaryAdress: String), Error> { promise in
            
            var urlComponents = URLComponents(string: "https://maps.googleapis.com/maps/api/geocode/json")
            urlComponents?.queryItems = [
                URLQueryItem(name: "latlng", value: "\(location.latitude), \(location.longitude)"),
                URLQueryItem(name: "key", value: LocationAPI.GOOGLE_GEO_API_KEY)
            ]
            
            var urlRequest = URLRequest(url: urlComponents!.url!)
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard error == nil && data != nil else { promise(.failure(NSError())); return }
                
                do{
                    let json = try JSON(data: data!)
                    
                    // for the plus_code regions
                    guard !json["results"][0]["types"].arrayValue.contains("plus_code") else {
                        promise(.success((
                            mainAdress: json["results"][0]["formatted_address"].stringValue,
                            secondaryAdress: ""
                        )))
                        return
                    }
                    
                    // get the first array
                    let adressComponents = json["results"][0]["address_components"].arrayValue
                    
                    // fetching for the format City, COUNTRY
                    // we guard if can't find the city
                    guard let cityName = adressComponents.first { $0["types"].arrayValue.contains("administrative_area_level_1")}?["long_name"].stringValue else {
                        promise(.success((
                            mainAdress: adressComponents.first { $0["types"].arrayValue.contains("country")}!["short_name"].stringValue,
                            secondaryAdress: "No street"
                        )))
                        return
                    }
                    let shortCountry = adressComponents.first { $0["types"].arrayValue.contains("country")}!["short_name"].stringValue
                    
                    // for some location we can't fetch the street
                    if let street = adressComponents.first(where: { $0["types"].arrayValue.contains("route")}){
                        if let streetNumber = adressComponents.first(where: { $0["types"].arrayValue.contains("street_number")}){
                            promise(.success((
                                mainAdress: cityName + ", " + shortCountry,
                                secondaryAdress: street["long_name"].stringValue + ", " + streetNumber["long_name"].stringValue
                            )))
                            return
                        }
                    }
                    
                    // we return this when we can't fetch street
                    promise(.success((
                        mainAdress: cityName + ", " + shortCountry,
                        secondaryAdress: "No street"
                    )))
                    
                } catch (let error) {
                    promise(.failure(error))
                }
            }
            
            dataTask.resume()
        }
        
    }
    
    func getAdressIDForCurrentLocation(location: CLLocationCoordinate2D) -> Future<String, Error> {
        
        Future<String, Error> { promise in
            
            var urlComponents = URLComponents(string: "https://maps.googleapis.com/maps/api/geocode/json")
            urlComponents?.queryItems = [
                URLQueryItem(name: "latlng", value: "\(location.latitude), \(location.longitude)"),
                URLQueryItem(name: "key", value: LocationAPI.GOOGLE_GEO_API_KEY)
            ]
            
            var urlRequest = URLRequest(url: urlComponents!.url!)
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard error == nil && data != nil else { promise(.failure(NSError())); return }
                
                do{
                    let json = try JSON(data: data!)
                    
                    
                    // we return this when we can't fetch street
                    promise(.success((
                        json["results"][0]["place_id"].stringValue
                    )))
                    
                } catch (let error) {
                    promise(.failure(error))
                }
            }
            
            dataTask.resume()
        }
        
    }
    
    func getPredictionsFromInput(textSearched: String) -> Future<[(addressName: String, addressID: String)], Error> {
        Future<[(addressName: String, addressID: String)], Error> { promise in
            
            var urlComponents = URLComponents(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json")
            urlComponents?.queryItems = [
                URLQueryItem(name: "input", value: textSearched),
                URLQueryItem(name: "location", value: "\(String(describing: LocationService.shared.locationManager.location?.coordinate.latitude)), \(String(describing: LocationService.shared.locationManager.location?.coordinate.longitude))"),
                URLQueryItem(name: "key", value: LocationAPI.GOOGLE_GEO_API_KEY)
            ]
            
            var urlRequest = URLRequest(url: (urlComponents?.url!)!)
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                
                guard error == nil else { promise(.failure(error!)); return }
                guard let data else { return }
                
                do {
                    let json = try JSON(data: data)
                    
                    var arrayToReturn = [(addressName: String, addressID: String)]()
                    
                    for prediction in json["predictions"].arrayValue {
                        arrayToReturn.append((
                            addressName: prediction["description"].stringValue,
                            addressID: prediction["place_id"].stringValue
                        ))
                    }
                    
                    promise(.success(arrayToReturn))
                    
                } catch (let error) {
                    promise(.failure(error))
                }
            }
            
            dataTask.resume()
        }
    }

    func getCoordinatesFromLocationID(ID: String) -> Future<CLLocationCoordinate2D, Error> {
        Future<CLLocationCoordinate2D, Error> { promise in
            
            var urlComponents = URLComponents(string: "https://maps.googleapis.com/maps/api/geocode/json")
            urlComponents?.queryItems = [
                URLQueryItem(name: "place_id", value: ID),
                URLQueryItem(name: "key", value: LocationAPI.GOOGLE_GEO_API_KEY)
            ]
            
            var urlRequest = URLRequest(url: urlComponents!.url!)
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard error == nil else { promise(.failure(error!)); return }
                guard let data else { return }
                
                do {
                    let json = try JSON(data: data)["results"][0]["geometry"]["location"]
                    
                    promise(.success(CLLocationCoordinate2D(
                        latitude: json["lat"].doubleValue,
                        longitude: json["lng"].doubleValue
                    )))
                    
                } catch (let error) {
                    promise(.failure(error))
                }
            }
            
            dataTask.resume()
        }
    }
}
