//
//  WeatherForecastView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 09.08.2023.
//

import SwiftUI
import CoreLocation

struct WeatherForecastView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var navigation: Navigation
    @StateObject var viewModel: WeatherForecastViewModel
    
    var body: some View {
        VStack {
            switch viewModel.fetchingState {
            case .loading :
                
                LoaderView()
                    .frame(width: 100, height: 100)
                
            case .loaded:
                VStack {
                    
                    BackButton(text: "Home")
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 35) {
                            Text("Weather - 7 days forecast")
                                .foregroundColor(.white)
                                .font(.abel(size: 32))
                            
                            ForEach(0..<viewModel.daysOfWeek.count) { dayOfWeek in
                                VStack(spacing: 24) {
                                    
                                    Button {
                                        
                                        navigation.push(HomeView(viewModel: HomeViewModel(
                                            locationWeatherModel: viewModel.weaTherWeekForecast[dayOfWeek]), isShowingAsChild: true
                                        ).asDestination(), animated: true)
                                        
                                    } label: {
                                        // day of the week
                                        HStack {
                                            Text(viewModel.daysOfWeek[dayOfWeek])
                                                .font(.abel(size: 24))
                                                .foregroundColor(.white)
                                            
                                            Spacer()
                                            
                                            
                                            
                                            Image(systemName: "chevron.right")
                                                .resizable()
                                                .renderingMode(.template)
                                                .foregroundColor(.white)
                                                .scaledToFit()
                                                .frame(width: 16, height: 16)
                                        }
                                        
                                    }
                                    
                                    HStack {
                                        // temperature
                                        ZStack {
                                            Color("accent.blue")
                                                .frame(width: UIScreen.main.bounds.width / 4,  height: UIScreen.main.bounds.width / 4)
                                                .cornerRadius(12)
                                            
                                            Text("\(viewModel.weaTherWeekForecast[dayOfWeek].temperature) ºC")
                                                .font(.abel(size: 36))
                                                .foregroundColor(.white)
                                        }
                                        
                                        Spacer()
                                        
                                        // weather icon
                                        ZStack {
                                            
                                            Color("accent.blue")
                                                .frame(width: UIScreen.main.bounds.width / 4,  height: UIScreen.main.bounds.width / 4)
                                                .cornerRadius(12)
                                            
                                            Image(systemName: viewModel.weaTherWeekForecast[dayOfWeek].weatherIcon)
                                                .resizable()
                                                .frame(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7)
                                                .scaledToFit()
                                        }
                                        
                                        Spacer()
                                        
                                        // wind speed
                                        ZStack {
                                            
                                            Color("accent.blue")
                                                .frame(width: UIScreen.main.bounds.width / 4,  height: UIScreen.main.bounds.width / 4)
                                                .cornerRadius(12)
                                            
                                            VStack   {
                                                Image(systemName: "flag")
                                                    .resizable()
                                                    .frame(width: UIScreen.main.bounds.width / 12, height: UIScreen.main.bounds.width / 12)
                                                    .scaledToFit()
                                                
                                                Text("\(viewModel.weaTherWeekForecast[dayOfWeek].windSpeed) km/h")
                                            }
                                        }
                                    }
                                }
                            }
                            
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                    }
                }
            case .failure:
                Text("Retry")
                    .foregroundColor(.white)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
    }
}

struct WeatherForecastView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherForecastView(viewModel: WeatherForecastViewModel(location: CLLocationCoordinate2D()))
    }
}
