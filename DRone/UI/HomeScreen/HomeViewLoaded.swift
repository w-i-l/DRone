//
//  HomeViewLoaded.swift
//  DRone
//
//  Created by Mihai Ocnaru on 09.08.2023.
//

import SwiftUI

struct HomeViewLoaded: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var navigation: Navigation
    @ObservedObject var viewModel: HomeViewModel
    
    let isShowingAsChild: Bool
    
    var body: some View {
        VStack {
            
            if isShowingAsChild {
                // back button
                BackButton(text: "Weekly forecast")
            }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    HStack {
                        // current location
                        Button {
                            navigation.push( ChangeLocationView(viewModel: viewModel.changeLocationViewModel)
                                .onAppear{ viewModel.changeLocationViewModel.searchLocationViewModel.textSearched = "" }.asDestination(), animated: true)
                        } label: {
                            HStack(spacing: 0) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(viewModel.locationWeatherModel.mainLocation.limitLettersFormattedString(limit: 20))
                                        .font(.abel(size: 32))
                                        .foregroundColor(.white)
                                        .underline(!isShowingAsChild)
                                    
                  
                                    
                                    Text(viewModel.locationWeatherModel.secondaryLocation != "No street" ?
                                         viewModel.locationWeatherModel.secondaryLocation.limitLettersFormattedString(limit: 30) :
                                        ""
                                    )
                                        .font(.abel(size: 20))
                                        .foregroundColor(Color("subtitle.gray"))

                                }
                                
                                Spacer()
                                
                            }
                        }
                        .disabled(isShowingAsChild)
                        
                        
                        
                        Spacer()
                        
                        if !isShowingAsChild {
                            Button {
                                viewModel.updateUI()
                            } label: {
                                Image(systemName: "arrow.clockwise")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                                    .scaledToFit()
                            }
                        }
                    }
                    
                    // current temperature
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("\(viewModel.locationWeatherModel.temperature)º C")
                                .font(.abel(size: 64))
                                .foregroundColor(.white)
                            
                            Text(viewModel.locationWeatherModel.weatherStatus)
                                .font(.abel(size: 20))
                                .foregroundColor(Color("subtitle.gray"))
                        }
                        
                        Spacer()
                        
                        Image(systemName: viewModel.locationWeatherModel.weatherIcon)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 100, height: 100)
                            .scaledToFit()
                    }
                    .padding(.top, 32)
                    
                    Button {
                        navigation.push(
                            WeatherVerdictView(viewModel: viewModel).asDestination(),
                            animated: true
                        )
                    } label: {
                        
                        
                        
                        // weather verdict
                        ZStack(alignment: .leading) {
                            LinearGradient(
                                colors: viewModel.weatherVerdict.1,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .cornerRadius(12)
                            
                            Text(viewModel.weatherVerdict.0)
                                .font(.abel(size: 32))
                                .foregroundColor(Color("background.first"))
                                .padding(.leading, 20)
                        }
                        .frame(height: UIScreen.main.bounds.height / 10)
                        .padding(.top, 32)
                    }
                    
                    // main weather infos
                    Link(
                        destination: viewModel.weatherURL,
                        label: {
                        ZStack {
                            Color("gray.background")
                                .cornerRadius(12)
                            
                            HStack {
                                ForEach([
                                    ("sunset", "Sunset", viewModel.locationWeatherModel.sunset),
                                    ("cloud.rain", "Prec. prob.", "\(viewModel.locationWeatherModel.precipitationProbability)%"),
                                    ("flag", "Wind speed", "\(viewModel.locationWeatherModel.windSpeed) km/h")
                                ], id: \.0) { item in
                                    Spacer()
                                    VStack {
                                        Image(systemName: item.0)
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundColor(.white)
                                            .frame(width: 40, height: 40)
                                            .scaledToFit()
                                        
                                        Text(item.1)
                                            .font(.abel(size: 16))
                                            .foregroundColor(.white)
                                        
                                        Text(item.2)
                                            .font(.abel(size: 20))
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                }
                            }
                            .padding(.vertical, 10)
                        }
                        .frame(height: UIScreen.main.bounds.height / 6.7)
                    .padding(.top, 30)
                    })
                    
                    // scodary weather infos
                    HStack(spacing: 15) {
                        ForEach( [
                            ("Wind \ndirection", viewModel.locationWeatherModel.windDirection),
                            ("Satellites \navailable", "\(viewModel.locationWeatherModel.satellites)"),
                            ("Visibility", "\(viewModel.locationWeatherModel.visibility) km")
                        ], id: \.0) { item in
                            
                            //
                            Link (
                                destination: viewModel.weatherURL,
                                label: {
                                ZStack {
                                    
                                    Color("gray.background")
                                        .frame(height: 100)
                                        .cornerRadius(12)
                                    
                                    VStack() {
                                        
                                        Spacer()
                                        
                                        Text(item.0)
                                            .font(.abel(size: 16))
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                        
                                        Spacer()
                                        
                                        Text(item.1)
                                            .font(.abel(size: 24))
                                            .foregroundColor(.white)
                                            .padding(.bottom, 10)
                                    }
                                    
                                }
                            })
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.height / 8)
                    .padding(.top, 20)
                    
                    if !isShowingAsChild {
                        // see more button
                        Button {
                            navigation.push(WeatherForecastView(viewModel: WeatherForecastViewModel(location: viewModel.addressToFetchLocation!)).asDestination(), animated: true)
                        } label: {
                            ZStack(alignment: .trailing) {
                                Color("accent.blue")
                                    .cornerRadius(12)
                                HStack {
                                    
                                    Text("See more infos ")
                                        .font(.abel(size: 20))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 12)
                                    
                                    
                                    
                                    Image(systemName: "arrow.forward")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                        .frame(width: 14, height: 14)
                                        .padding(.trailing, 20)
                                        .scaledToFit()
                                }
                                
                            }
                        }
                        .frame(width: 180)
                        .frame(height: 55)
                        .padding(.top, 30)
                    }
                    
                    Spacer()
                    
                }
                .padding(.bottom, UIScreen.main.bounds.height / 11.3)
            }
            .padding([.horizontal, .bottom], 20)
        }
        .onChange(of: viewModel.addressToFetchLocation) { newValue in
            viewModel.updateUI()
        }
    }
    
    init(viewModel: HomeViewModel, isShowingAsChild: Bool) {
        self.viewModel = viewModel
        self.isShowingAsChild = isShowingAsChild
        self.navigation = SceneDelegate.navigation
    }
}

struct HomeViewLoaded_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewLoaded(
            viewModel: HomeViewModel(),
            isShowingAsChild: false
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
    }
}
