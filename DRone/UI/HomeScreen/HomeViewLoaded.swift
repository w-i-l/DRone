//
//  HomeViewLoaded.swift
//  DRone
//
//  Created by Mihai Ocnaru on 09.08.2023.
//

import SwiftUI


struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        path.closeSubpath()
        
        return path
    }
    
    enum Direction: Double {
        case down = 0
        case left = 90
        case up = 180
        case right = 270
    }
}

struct HomeViewLoaded: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navigationHome: Navigation
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            
            if viewModel.isShowingAsChild {
                // back button
                BackButton(text: "Weekly forecast")
            }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    HStack {
                        // current location
                        Button {
                            navigationHome.push( ChangeLocationView(viewModel: viewModel.changeLocationViewModel)
                                .onAppear{ viewModel.changeLocationViewModel.searchLocationViewModel.textSearched = "" }.asDestination(), animated: true)
                        } label: {
                            HStack(spacing: 0) {
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack {
                                        Text(viewModel.locationWeatherModel.mainLocation.limitLettersFormattedString(limit: 15))
                                            .font(.asket(size: 32))
                                            .foregroundColor(.white)
                                        
                                        if !viewModel.isShowingAsChild {
                                            Image(systemName: "chevron.down")
                                                .resizable()
                                                .renderingMode(.template)
                                                .foregroundColor(Color.white.opacity(0.7))
                                                .frame(width: 16, height: 10)
                                                .scaledToFit()
                                        }
                                    }
                                    
                  
                                    
                                    Text(viewModel.locationWeatherModel.secondaryLocation != "No street" ?
                                         viewModel.locationWeatherModel.secondaryLocation.limitLettersFormattedString(limit: 30) :
                                        ""
                                    )
                                        .font(.asket(size: 20))
                                        .foregroundColor(Color("subtitle.gray"))

                                }
                                
                                Spacer()
                                
                            }
                        }
                        .disabled(viewModel.isShowingAsChild)
                        
                        
                        
                        Spacer()
                        
                        if !viewModel.isShowingAsChild {
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
                                .font(.asket(size: 64))
                                .foregroundColor(.white)
                            
                            Text(viewModel.locationWeatherModel.weatherStatus)
                                .font(.asket(size: 20))
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
                        navigationHome.push(
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
                            
                            HStack {
                                Text(viewModel.weatherVerdict.0)
                                    .font(.asket(size: 32))
                                    .foregroundColor(Color("background.first"))
                                
                                Spacer()
                                
                                Image(systemName: "info.circle.fill")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color("background.first"))
                                    .frame(width: 24, height: 24)
                                    .scaledToFit()
                            }
                            .padding(.horizontal, 20)
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
                            
                            
                            // external link arrow
                            Group {
                                
                                VStack {
                                    
                                    
                                    Spacer()
                                    
                                    HStack {
                                        
                                        Spacer()
                                        TriangleShape()
                                            .fill(Color.white.opacity(0.3))
                                            .frame(width: 60, height: 60)
                                            .rotationEffect(.degrees(90))
                                    }
                                    
                                }
                                .offset(y: 30)
                                .clipped()
                                
                                VStack {
                                    
                                    
                                    Spacer()
                                    
                                    HStack {
                                        
                                        Spacer()
                                        Color.white.opacity(0.7)
                                            .frame(width: 1, height: 60)
                                            .rotationEffect(.degrees(45))
                                        
                                    }
                                    
                                }
                                .padding(.vertical, 0)
                                .padding(.horizontal, 5)
                                .offset(x: -5, y: 10)
                                .clipped()
                                
                                VStack {
                                    
                                    Spacer()
                                    
                                    HStack {
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.right")
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundColor(.white)
                                            .frame(width: 7, height: 7)
                                            .scaledToFit()
                                    }
                                }
                                .padding(.horizontal, 5)
                                .padding(.vertical, 7)
                            }
                                
                            HStack {
                                ForEach([
                                    ("sunset.fill", "Sunset", viewModel.locationWeatherModel.sunset),
                                    ("cloud.rain.fill", "Prec. prob.", "\(viewModel.locationWeatherModel.precipitationProbability)%"),
                                    ("flag.fill", "Wind speed", "\(viewModel.locationWeatherModel.windSpeed) km/h")
                                ], id: \.0) { item in
                                    Spacer()
                                    VStack(spacing: 0) {
                                        Image(systemName: item.0)
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundColor(.white)
                                            .frame(width: 40, height: 40)
                                            .scaledToFit()
                                        
                                        Text(item.1)
                                            .font(.asket(size: 12))
                                            .foregroundColor(.white.opacity(0.7))
                                            .padding(.top, 10)
                                            .padding(.bottom, 3)
                                        
                                        Text(item.2)
                                            .font(.asket(size: 16))
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
                                            .font(.asket(size: 14))
                                            .foregroundColor(.white.opacity(0.7))
                                            .multilineTextAlignment(.center)
                                        
                                        Spacer()
                                        
                                        Text(item.1)
                                            .font(.asket(size: 20))
                                            .foregroundColor(.white)
                                            .padding(.bottom, 10)
                                    }
                                    .padding(10)
                                    
                                }
                            })
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.height / 8)
                    .padding(.top, 20)
                    
                    if !viewModel.isShowingAsChild {
                        // see more button
                        Button {
                            navigationHome.push(WeatherForecastView(viewModel: WeatherForecastViewModel(location: viewModel.addressToFetchLocation!)).asDestination(), animated: true)
                        } label: {
                            ZStack(alignment: .trailing) {
                                Color("accent.blue")
                                    .cornerRadius(12)
                                HStack {
                                    
                                    Text("See more infos ")
                                        .font(.asket(size: 20))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 5)
                                    
                                    
                                    
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                        .frame(width: 12, height: 12)
                                        .padding(.trailing, 20)
                                        .scaledToFit()
                                }
                                
                            }
                        }
                        .frame(width: 200)
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
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
}

struct HomeViewLoaded_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewLoaded(
            viewModel: HomeViewModel(isShowingAsChild: false)            
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
    }
}
