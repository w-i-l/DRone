//
//  LocationWeatherModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 07.08.2023.
//

import Foundation

struct LocationWeatherModel {
    let temperature: Int
    let sunset: String
    let weatherStatus: String
    let weatherIcon: String
    let precipitationProbability: Int
    let windSpeed: Int
    let windDirection: String
    let visibility: Int
    let satellites: Int
    let mainLocation: String
    let secondaryLocation: String
}
