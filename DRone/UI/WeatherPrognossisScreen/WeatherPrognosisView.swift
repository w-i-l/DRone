//
//  WeatherPrognosisView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 09.08.2023.
//

import SwiftUI
import CoreLocation

struct WeatherPrognosisView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: WeatherPrognosisViewModel
    
    var body: some View {
        VStack {
            switch viewModel.fetchingState {
            case .loading :
                
                LoaderView()
                    .frame(width: 100, height: 100)
                
            case .loaded:
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 35) {
                        Text("Weather - 7 days prognosis")
                            .foregroundColor(.white)
                            .font(.abel(size: 32))
                        
                        ForEach(0..<viewModel.daysOfWeek.count) { dayOfWeek in
                            VStack(spacing: 24) {
                                
                                NavigationLink {
                                    HomeView(viewModel: HomeViewModel(
                                        locationWeatherModel: viewModel.weaTherWeekPrognosis[dayOfWeek]), isShowingAsChild: true
                                    )
                                    .navigationBarBackButtonHidden(true)
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
                                        
                                        Text("\(viewModel.weaTherWeekPrognosis[dayOfWeek].temperature) ºC")
                                            .font(.abel(size: 36))
                                            .foregroundColor(.white)
                                    }
                                    
                                    Spacer()
                                    
                                    // weather icon
                                    ZStack {
                                        
                                        Color("accent.blue")
                                            .frame(width: UIScreen.main.bounds.width / 4,  height: UIScreen.main.bounds.width / 4)
                                            .cornerRadius(12)
                                        
                                        Image(systemName: viewModel.weaTherWeekPrognosis[dayOfWeek].weatherIcon)
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
                                            
                                            Text("\(viewModel.weaTherWeekPrognosis[dayOfWeek].windSpeed) km/h")
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
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
        .navigationBarItems(leading:
            Button {
                dismiss()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 14, height: 14)
                    .scaledToFit()
                    .foregroundColor(.white)
                
                
                Text("Home")
                    .font(.abel(size: 24))
                    .foregroundColor(.white)
            }
        })
       
    }
}

struct WeatherPrognosisView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherPrognosisView(viewModel: WeatherPrognosisViewModel(location: CLLocationCoordinate2D()))
    }
}
