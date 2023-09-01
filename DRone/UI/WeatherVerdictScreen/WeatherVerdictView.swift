//
//  WeatherVerdictView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 28.08.2023.
//

import SwiftUI
import BottomSheet

internal struct WeatherVerdictModalModel {
    let title: String
    let current: Int
    let ideal : Int
    let good: Int
    let bad: String
    let format: String
}


struct WeatherVerdictView: View {
    
    
    internal let weatherVerdictModalModelArray: [WeatherVerdictModalModel]
    
    @StateObject var viewModel: HomeViewModel
    @StateObject private var verdictViewModel: WeatherVerdictViewModel = .init()
    @EnvironmentObject private var navigation: Navigation
    
    init(viewModel: HomeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.weatherVerdictModalModelArray = [
            WeatherVerdictModalModel(
                title: "Precipitation probability",
                current: viewModel.locationWeatherModel.precipitationProbability,
                ideal: WeatherService.shared.precipitationProbabilityIdealCondition,
                good: WeatherService.shared.precipitationProbabilityGoodCondition,
                bad: "> \(WeatherService.shared.precipitationProbabilityGoodCondition)",
                format: "%"
            ),
            WeatherVerdictModalModel(
                title: "Satellites available",
                current: viewModel.locationWeatherModel.satellites,
                ideal: WeatherService.shared.satellitesIdealCondition,
                good: WeatherService.shared.satellitesGoodContion,
                bad: "< \(WeatherService.shared.satellitesGoodContion)",
                format: ""
            ),
            WeatherVerdictModalModel(
                title: "Temperature",
                current: viewModel.locationWeatherModel.temperature,
                ideal: WeatherService.shared.temperatureIdealCondition,
                good: WeatherService.shared.temperatureGoodContion,
                bad: "< \(WeatherService.shared.temperatureGoodContion)",
                format: " º C"
            ),
            WeatherVerdictModalModel(
                title: "Visibility",
                current: viewModel.locationWeatherModel.visibility,
                ideal: WeatherService.shared.visibilityIdealCondition,
                good: WeatherService.shared.visibilityGoodContion,
                bad: "< \(WeatherService.shared.visibilityGoodContion)",
                format: " km"
            ),
            WeatherVerdictModalModel(
                title: "Wind speed",
                current: viewModel.locationWeatherModel.windSpeed,
                ideal: WeatherService.shared.windSpeedIdealCondition,
                good: WeatherService.shared.windSpeedGoodCondition,
                bad: "> \(WeatherService.shared.windSpeedGoodCondition + 1)",
                format: " km/h"
            )
        ]
    }
    
    var body: some View {
        VStack {
            BackButton(text: "Home")
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // weather verdict
                    ZStack(alignment: .leading) {
                        LinearGradient(
                            colors: viewModel.weatherVerdict.1,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .cornerRadius(12)
                        
                        Text(viewModel.weatherVerdict.0)
                            .font(.asket(size: 32))
                            .foregroundColor(Color("background.first"))
                            .padding(.leading, 20)
                    }
                    .frame(height: UIScreen.main.bounds.height / 10)
                    .padding(.top, 32)
                    
                    Text("How is it determined?")
                        .foregroundColor(.white)
                        .font(.asket(size: 24))
                        .padding(.top, 48)
                        .padding(.bottom, 24)
                    
                    VStack {
                        ForEach([
                            (
                                "Precipitation probability",
                                "\(viewModel.locationWeatherModel.precipitationProbability)%",
                                weatherVerdictModalModelArray[0],
                                verdictViewModel.displayPrecipitationBottomSheet,
                                (
                                    isIdeal: viewModel.locationWeatherModel.precipitationProbability <= weatherVerdictModalModelArray[0].ideal,
                                    isGood: viewModel.locationWeatherModel.precipitationProbability <= weatherVerdictModalModelArray[0].good
                                )
                            ),
                            (
                                "Satellites available",
                                "\(viewModel.locationWeatherModel.satellites)",
                                weatherVerdictModalModelArray[1],
                                verdictViewModel.displaySatellitesBottomSheet,
                                (
                                    isIdeal: viewModel.locationWeatherModel.satellites >= weatherVerdictModalModelArray[1].ideal,
                                    isGood: viewModel.locationWeatherModel.satellites >= weatherVerdictModalModelArray[1].good
                                )
                            ),
                            (
                                "Temperature",
                                "\(viewModel.locationWeatherModel.temperature)º C",
                                weatherVerdictModalModelArray[2],
                                verdictViewModel.displayTemperatureBottomSheet,
                                (
                                    isIdeal: viewModel.locationWeatherModel.temperature >= weatherVerdictModalModelArray[2].ideal,
                                    isGood: viewModel.locationWeatherModel.temperature >= weatherVerdictModalModelArray[2].good
                                )
                            ),
                            (
                                "Visibility",
                                "\(viewModel.locationWeatherModel.visibility) km",
                                weatherVerdictModalModelArray[3],
                                verdictViewModel.displayVisibilityBottomSheet,
                                (
                                    isIdeal: viewModel.locationWeatherModel.visibility >= weatherVerdictModalModelArray[3].ideal,
                                    isGood: viewModel.locationWeatherModel.visibility >= weatherVerdictModalModelArray[3].good
                                )
                            ),
                            (
                                "Wind speed",
                                "\(viewModel.locationWeatherModel.windSpeed) km/h",
                                weatherVerdictModalModelArray[4],
                                verdictViewModel.displayWindSpeedBottomSheet,
                                (
                                    isIdeal: viewModel.locationWeatherModel.windSpeed <= weatherVerdictModalModelArray[4].ideal,
                                    isGood: viewModel.locationWeatherModel.windSpeed <= weatherVerdictModalModelArray[4].good
                                )
                            )
                        ], id: \.0) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    
                                    // current values
                                    HStack {
                                        Text(item.0)
                                            .foregroundColor(.white)
                                            .font(.asket(size: 18))
                                        
                                        Spacer()
                                        
                                        
                                    }
                                    .frame(width: UIScreen.main.bounds.width - 150)
                                    
                                    // condition review
                                    HStack {
                                        if item.4.isIdeal {
                                            Text("Ideal")
                                                .foregroundColor(Color("subtitle.gray"))
                                                .font(.asket(size: 16))
                                            
                                            Circle()
                                                .fill(Color("green"))
                                                .frame(width: 16)
                                        } else if item.4.isGood {
                                            Text("Good")
                                                .foregroundColor(Color("subtitle.gray"))
                                                .font(.asket(size: 16))
                                            
                                            Circle()
                                                .fill(Color("yellow"))
                                                .frame(width: 16)
                                        } else {
                                            Text("Bad")
                                                .foregroundColor(Color("subtitle.gray"))
                                                .font(.asket(size: 16))
                                            
                                            Circle()
                                                .fill(Color("red"))
                                                .frame(width: 16)
                                        }
                                    }
                                    
                                    
                                }
                                .padding(.top, 24)
                                
                                
                                Spacer()
                                
                                Text("\(item.2.current)\(item.2.format)")
                                    .foregroundColor(.white)
                                    .font(.asket(size: 18))
                                    .padding(.trailing, 20)
                                
                                // info button
                                Button {
                                    item.3()
                                } label: {
                                    Image(systemName: "info.circle")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                        .frame(width: 24, height: 24)
                                }
                                
                            }
                            
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
        .bottomSheet(
            bottomSheetPosition: $verdictViewModel.precipitationBottomSheetPosition,
            switchablePositions: [.relativeTop(0.4)]) {
                WeatherVerdictModal(weatherVerdictModalModel: self.weatherVerdictModalModelArray[0],
            condition: (
                viewModel.locationWeatherModel.precipitationProbability <= weatherVerdictModalModelArray[0].ideal,
                viewModel.locationWeatherModel.precipitationProbability <= weatherVerdictModalModelArray[0].good
            ))
        }
        .enableTapToDismiss()
        .enableSwipeToDismiss(true)
        .customBackground {
            Color("background.first")
        }
        
        .bottomSheet(
            bottomSheetPosition: $verdictViewModel.satellitesBottomSheetPosition,
            switchablePositions: [.relativeTop(0.4)]) {
                WeatherVerdictModal(weatherVerdictModalModel: self.weatherVerdictModalModelArray[1],
            condition:
                (
                viewModel.locationWeatherModel.satellites >= weatherVerdictModalModelArray[1].ideal,
                    viewModel.locationWeatherModel.satellites >= weatherVerdictModalModelArray[1].good
                ))
        }
        .enableTapToDismiss()
        .enableSwipeToDismiss()
        .customBackground {
            Color("background.first")
        }
        
        .bottomSheet(
            bottomSheetPosition: $verdictViewModel.temperatureBottomSheetPosition,
            switchablePositions: [.relativeTop(0.4)]) {
                WeatherVerdictModal(weatherVerdictModalModel: self.weatherVerdictModalModelArray[2],
                condition: (
                    viewModel.locationWeatherModel.temperature >= weatherVerdictModalModelArray[2].ideal,
                    viewModel.locationWeatherModel.temperature >= weatherVerdictModalModelArray[2].good
                ))
        }
        .enableTapToDismiss()
        .enableSwipeToDismiss()
        .customBackground {
            Color("background.first")
        }
        
        .bottomSheet(
            bottomSheetPosition: $verdictViewModel.visibilityBottomSheetPosition,
            switchablePositions: [.relativeTop(0.4)]) {
                WeatherVerdictModal(weatherVerdictModalModel: self.weatherVerdictModalModelArray[3],
            condition: (
                viewModel.locationWeatherModel.visibility >= weatherVerdictModalModelArray[3].ideal,
                viewModel.locationWeatherModel.visibility >= weatherVerdictModalModelArray[3].good
            ))
        }
        .enableTapToDismiss()
        .enableSwipeToDismiss()
        .customBackground {
            Color("background.first")
        }
        
        .bottomSheet(
            bottomSheetPosition: $verdictViewModel.windSpeedBottomSheetPosition,
            switchablePositions: [.relativeTop(0.4)]) {
                WeatherVerdictModal(weatherVerdictModalModel: self.weatherVerdictModalModelArray[4],
            condition: (
                viewModel.locationWeatherModel.windSpeed <= weatherVerdictModalModelArray[4].ideal,
                viewModel.locationWeatherModel.windSpeed <= weatherVerdictModalModelArray[4].good
            ))
        }
        .enableTapToDismiss()
        .enableSwipeToDismiss(true)
        .customBackground {
            Color("background.first")
        }
    }
}

struct WeatherVerdictView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherVerdictView(viewModel: HomeViewModel(isShowingAsChild: false))
    }
}
