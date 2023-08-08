//
//  HomeView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 07.08.2023.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            switch viewModel.fetchingState {
            case .loading :
                ProgressView()
                    .tint(Color.white)
                
            case .loaded:
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        
                        // current location
                        HStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Bucharest, RO")
                                    .font(.abel(size: 32))
                                    .foregroundColor(.white)
                                    .underline(true)
                                
                                Text("Calea Victoriei, Nr. 18, 153340")
                                    .font(.abel(size: 20))
                                    .foregroundColor(Color("subtitle.gray"))
                            }
                            
                            Spacer()
                            
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
                        }
                        .padding(.top, 32)
                        
                        // flight verdict
                        ZStack(alignment: .leading) {
                            LinearGradient(
                                colors: [.green, Color("green")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .cornerRadius(12)
                            
                            Text("Good to fly")
                                .font(.abel(size: 32))
                                .foregroundColor(Color("background.first"))
                                .padding(.leading, 20)
                        }
                        .frame(height: UIScreen.main.bounds.height / 10)
                        .padding(.top, 32)
                        
                        // main weather infos
                        ZStack {
                            Color("gray.background")
                                .cornerRadius(12)
                            
                            HStack {
                                ForEach([
                                    ("sunset", "Sunset", viewModel.locationWeatherModel.sunset),
                                    ("cloud.rain", "Prec. prob.", "\(viewModel.locationWeatherModel.precipitaionProbability)%"),
                                    ("flag", "Wind speed", "\(viewModel.locationWeatherModel.windSpeed) km/h")
                                ], id: \.0) { item in
                                    Spacer()
                                    VStack {
                                        Image(systemName: item.0)
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundColor(.white)
                                            .frame(width: 40, height: 40)
                                        
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
                        
                        // scodary weather infos
                        HStack(spacing: 15) {
                            ForEach( [
                                ("Wind \ndirection", viewModel.locationWeatherModel.windDirection),
                                ("Satellites \navailible", "\(viewModel.locationWeatherModel.satellites)"),
                                ("Visibility", "\(viewModel.locationWeatherModel.visibility) km")
                            ], id: \.0) { item in
                                
                                //
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
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: UIScreen.main.bounds.height / 8)
                        .padding(.top, 20)
                        
                        // see more button
                        NavigationLink {
                            
                        } label: {
                            ZStack(alignment: .trailing) {
                                Color("accent.blue")
                                    .cornerRadius(12)
                                HStack {
                                    
                                    Text("See more infos ")
                                        .font(.abel(size: 20))
                                        .foregroundColor(Color("background.first"))
                                        .padding(.vertical, 12)
                                    
                                    
                                    
                                    Image(systemName: "arrow.forward")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color("background.first"))
                                        .frame(width: 14, height: 14)
                                        .padding(.trailing, 20)
                                }
                                
                            }
                        }
                        .frame(width: 180)
                        .frame(height: 55)
                        .padding(.top, 30)
                        
                        
                        Spacer()
                        
                    }
                    .padding(.bottom, UIScreen.main.bounds.height / 11.3)
                }
                .padding([.horizontal, .bottom], 20)
                
                
            case .failure :
                Text("Failed to fetch data")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
        )
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
