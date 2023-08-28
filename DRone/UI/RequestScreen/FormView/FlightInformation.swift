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
                        
                        Text("Flight information")
                            .font(.asket(size: 36))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        Text("Complete the form with your flight information")
                            .font(.asket(size: 16))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        VStack {
                            
                            // flight date
                            HStack(spacing: 8) {
                                Text("Flight date")
                                    .foregroundColor(.white)
                                    .font(.asket(size: 20))
                                
                                Spacer()
                                
                                DatePicker(selection: $viewModel.flightDate,
                                           in: Date()...(Date() + viewModel.maximumDayToRequest),
                                           displayedComponents: .date) {
                                    Text("Date")
                                        .foregroundColor(.white)
                                        .font(.asket(size: 20))
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
                                        .foregroundColor(.white)
                                        .font(.asket(size: 20))
                                    
                                    DatePicker(selection: $viewModel.takeoffTime,
                                               in: ...viewModel.sunsetHourToday,
                                               displayedComponents: .hourAndMinute) {
                                        Text("Date")
                                            .foregroundColor(.white)
                                            .font(.asket(size: 20))
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
                                        .foregroundColor(.white)
                                        .font(.asket(size: 20))
                                    
                                    // AT LEAST 10 MINUTES DIFFERENCE
                                    DatePicker(selection: $viewModel.landingTime,
                                               in: (viewModel.takeoffTime + viewModel.minimumFlightTime)...(viewModel.sunsetHourToday + viewModel.minimumFlightTime),
                                               displayedComponents: .hourAndMinute) {
                                        Text("Date")
                                            .foregroundColor(.white)
                                            .font(.asket(size: 20))
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
                                    .foregroundColor(.white)
                                    .font(.asket(size: 20))
                                
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
                                            Image(systemName: "mappin.circle")
                                                .resizable()
                                                .renderingMode(.template)
                                                .foregroundColor(.white)
                                                .frame(width: 24, height: 24)
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
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 10)
                                        .background(Color("gray.background").cornerRadius(12))
                                    })
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 32)
                        }
                        // progress
                        
                        Spacer()
                        
                        
                        // next
                        HStack {
                            Spacer()
                            Button(
                                action: {
                                    
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    
                                    viewModel.getResponse()
                                    viewModel.showNavigationLink = true
                                    viewModel.postFlightRequestFor()
                                    
                                }, label: {
                                    ZStack {
                                        Color("accent.blue")
                                            .cornerRadius(20)
                                            .frame(height: 50)
                                        
                                        HStack {
                                            Text("Next")
                                                .foregroundColor(.white)
                                                .font(.asket(size: 32))
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .resizable()
                                                .renderingMode(.template)
                                                .foregroundColor(.white)
                                                .frame(width: 18, height: 18)
                                                .scaledToFit()
                                        }
                                        .padding(15)
                                    }
                                    .frame(width: 150 ,height: 50)
                                })
                            .padding(.top, UIScreen.main.bounds.height / 20)
                            
                            Spacer()
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
