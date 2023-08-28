//
//  WeatherVerdictViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 28.08.2023.
//

import Foundation
import SwiftUI
import BottomSheet

class WeatherVerdictViewModel: BaseViewModel {
    @Published var precipitationBottomSheetPosition: BottomSheetPosition = .hidden
    @Published var satellitesBottomSheetPosition: BottomSheetPosition = .hidden
    @Published var windSpeedBottomSheetPosition: BottomSheetPosition = .hidden
    @Published var temperatureBottomSheetPosition: BottomSheetPosition = .hidden
    @Published var visibilityBottomSheetPosition: BottomSheetPosition = .hidden
    
    func displayPrecipitationBottomSheet() {
        precipitationBottomSheetPosition = .relativeTop(0.6)
    }
    func displaySatellitesBottomSheet() {
        satellitesBottomSheetPosition = .relativeTop(0.6)
    }
    func displayWindSpeedBottomSheet() {
        windSpeedBottomSheetPosition = .relativeTop(0.6)
    }
    func displayTemperatureBottomSheet() {
        temperatureBottomSheetPosition = .relativeTop(0.6)
    }
    func displayVisibilityBottomSheet() {
        visibilityBottomSheetPosition = .relativeTop(0.6)
    }
    
}
