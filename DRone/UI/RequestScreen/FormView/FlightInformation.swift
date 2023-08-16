//
//  FlightInformation.swift
//  DRone
//
//  Created by Mihai Ocnaru on 16.08.2023.
//

import SwiftUI

struct FlightInformation: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showNavigationLink: Bool = false
    @ObservedObject var viewModel: RequestViewModel
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        
                        Text("Flight information")
                            .font(.abel(size: 40))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        Text("Complete the form with your flight information")
                            .font(.abel(size: 18))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        VStack {
                            // Takeoff number
                            HStack {
                                VStack(spacing: 8) {
                                    Text("Takeoff time")
                                        .foregroundColor(.white)
                                        .font(.abel(size: 20))
                                    
                                    DatePicker(selection: $viewModel.takeoffTime,
                                               in: Date()...,
                                               displayedComponents: .hourAndMinute) {
                                        Text("Date")
                                            .foregroundColor(.white)
                                            .font(.abel(size: 20))
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
                                        .font(.abel(size: 20))
                                    
                                    DatePicker(selection: $viewModel.landingTime,
                                               in: viewModel.takeoffTime...,
                                               displayedComponents: .hourAndMinute) {
                                        Text("Date")
                                            .foregroundColor(.white)
                                            .font(.abel(size: 20))
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
                                    .font(.abel(size: 20))
                                
                                NavigationLink(
                                    destination: {
                                        ChangeLocationView(viewModel: viewModel.changeLocationViewModel)
                                            .navigationBarBackButtonHidden(true)
                                            .onAppear {
                                                viewModel.changeLocationViewModel.searchLocationViewModel.textSearched = ""
                                            }
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
                                                    .font(.abel(size: 16))
                                                
                                                Text(viewModel.flightLocation.secondaryAdress.limitLettersFormattedString(limit: 30))
                                                    .foregroundColor(Color("subtitle.gray"))
                                                    .font(.abel(size: 12))
                                                
                                            }
                                            Spacer()
                                        }
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 10)
                                        .background(Color("gray.background"))
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
                                    viewModel.getResponse()
                                    showNavigationLink = true
                                }, label: {
                                    ZStack {
                                        Color("accent.blue")
                                            .cornerRadius(20)
                                            .frame(height: 50)
                                        
                                        HStack {
                                            Text("Next")
                                                .foregroundColor(.white)
                                                .font(.abel(size: 32))
                                            
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
            if showNavigationLink {
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
        .sheet(
            isPresented: $viewModel.isDroneModalShown
        ){
            DroneTypeModal(viewModel: viewModel)
        }
    }
}

struct FlightInformation_Previews: PreviewProvider {
    static var previews: some View {
        FlightInformation(viewModel: RequestViewModel())
    }
}
