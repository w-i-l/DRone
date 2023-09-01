//
//  FlightInformation.swift
//  DRone
//
//  Created by Mihai Ocnaru on 16.08.2023.
//

import SwiftUI

struct FlightInformation: View {
    @Environment(\.dismiss) private var dismiss
   
    @ObservedObject var viewModel: RequestViewModel
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Flight information")
                                .font(.asket(size: 32))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            
                            Text("Complete the form with your flight information")
                                .font(.asket(size: 16))
                                .foregroundColor(Color("subtitle.gray"))
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.top, 10)
                        
                        Spacer()
                        
                        VStack {
                            
                            // flight date
                            HStack(spacing: 8) {
                                Text("Flight date")
                                    .foregroundColor(Color("subtitle.gray"))
                                    .font(.asket(size: 18))
                                
                                Spacer()
                                
                                DatePicker(selection: $viewModel.flightDate,
                                           in: Date()...(Date() + viewModel.maximumDayToRequest),
                                           displayedComponents: .date) {
                                    Text("Date")
                                        .foregroundColor(.white)
                                        .font(.asket(size: 18))
                                }
                                           .labelsHidden()
                                           .colorInvert()
                                           .colorMultiply(Color.white)
                                           .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                                           .colorScheme(.light)
                                
                            }
                            
                            // Takeoff number
                            HStack {
                                VStack(spacing: 8) {
                                    Text("Takeoff time")
                                        .foregroundColor(Color("subtitle.gray"))
                                        .font(.asket(size: 18))
                                    
                                    DatePicker(selection: $viewModel.takeoffTime,
                                               in: ...viewModel.sunsetHourToday,
                                               displayedComponents: .hourAndMinute) {
                                        Text("Date")
                                            .foregroundColor(.white)
                                            .font(.asket(size: 18))
                                    }
                                               .labelsHidden()
                                               .colorInvert()
                                               .colorMultiply(Color.white)
                                               .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                                               .colorScheme(.light)
                                    
                                }
                                
                                Spacer()
                                
                                VStack(spacing: 8) {
                                    Text("Landing time")
                                        .foregroundColor(Color("subtitle.gray"))
                                        .font(.asket(size: 18))
                                    
                                    // AT LEAST 10 MINUTES DIFFERENCE
                                    DatePicker(selection: $viewModel.landingTime,
                                               in: (viewModel.takeoffTime + viewModel.minimumFlightTime)...(viewModel.sunsetHourToday + viewModel.minimumFlightTime),
                                               displayedComponents: .hourAndMinute) {
                                        Text("Date")
                                            .foregroundColor(.white)
                                            .font(.asket(size: 18))
                                    }
                                               .labelsHidden()
                                               .colorInvert()
                                               .colorMultiply(Color.white)
                                               .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                                               .colorScheme(.light)
                                    
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                            
                            // flight location
                            VStack(alignment: .leading, spacing: 7) {
                                Text("Your flight location")
                                    .foregroundColor(Color("subtitle.gray"))
                                    .font(.asket(size: 18))
                                
                                Button(
                                    action: {
                                        navigation.push(
                                        ChangeLocationView(viewModel: viewModel.changeLocationViewModel)
                                            .navigationBarBackButtonHidden(true)
                                            .onAppear {
                                                viewModel.changeLocationViewModel.searchLocationViewModel.textSearched = ""
                                                navigation.navigationController.interactivePopGestureRecognizer?.isEnabled = true
                                            }
                                            .onDisappear {
                                                navigation.navigationController.interactivePopGestureRecognizer?.isEnabled = false
                                            }
                                            .asDestination(), animated: true)
                                        self.dismissKeyboard()
                                    }, label: {
                                        HStack(spacing: 14) {
                                            Image("map.pin")
                                                .resizable()
                                                .renderingMode(.template)
                                                .foregroundColor(.white)
                                                .frame(width: 20, height: 20)
                                                .scaledToFit()
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(viewModel.flightLocation.mainAdress.limitLettersFormattedString(limit: 30))
                                                    .foregroundColor(.white)
                                                    .font(.asket(size: 16))
                                                
                                                Text(viewModel.flightLocation.secondaryAdress.limitLettersFormattedString(limit: 30))
                                                    .foregroundColor(Color("subtitle.gray"))
                                                    .font(.asket(size: 12))
                                                
                                            }
                                            Spacer()
                                        }
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 10)
                                        .background(Color("gray.background").cornerRadius(12))
                                    })
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 32)
                        }
                        // progress
                        
                        Spacer()
                        
                        // next button
                        HStack {
                            Spacer()
                            
                            Button (action: {
                                
                                self.dismissKeyboard()
                                
                                viewModel.getResponse()
                                viewModel.showNavigationLink = true
                                viewModel.postFlightRequestFor()
                                
                            }, label: {
                                ZStack {
                                    Color("accent.blue")
                                        .cornerRadius(12)
                                        .frame(height: 60)
                                    
                                    HStack {
                                        Text("Send request")
                                            .foregroundColor(.white)
                                            .font(.asket(size: 24))
                                        
//                                        Image(systemName: "chevron.right")
//                                            .resizable()
//                                            .renderingMode(.template)
//                                            .foregroundColor(.white)
//                                            .frame(width: 10, height: 10)
//                                            .scaledToFit()
                                    }
                                    .padding(.vertical, 10)
                                }
                            })
                            
                        }
                        
                        
                    }
                    .padding(.horizontal, 20)
                    .frame(minHeight: proxy.size.height)
                }
            }
            if viewModel.showNavigationLink {
                ResponseScreen(viewModel: viewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationBarHidden(true)
                    .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                    )
                    .zIndex(3)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
    }
}

struct FlightInformation_Previews: PreviewProvider {
    static var previews: some View {
        FlightInformation(viewModel: RequestViewModel())
    }
}
