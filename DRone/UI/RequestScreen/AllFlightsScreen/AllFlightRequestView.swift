//
//  AllFlightRequestView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 17.08.2023.
//

import SwiftUI
import CoreLocation

struct AllFlightRequestView: View {
    
    @StateObject var viewModel: RequestViewModel
    @State private var isNavigationLinkShown: Bool = false
    @State private var showUpcomingFlights: Bool = true
    @State private var showCompletedFlights: Bool = true
    @EnvironmentObject private var navigation: Navigation
    
    var hourFormatter: DateFormatter {
        let hrFmt = DateFormatter()
        hrFmt.dateFormat = "HH:mm"
        return hrFmt
    }
    
    var dateFormatter: DateFormatter {
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "dd / MM / yyyy"
        return dateFmt
    }

    
    var body: some View {
        VStack {
            switch viewModel.fetchingState {
            case .loading:
                VStack {
                    LoaderView()
                        .frame(width: 32, height: 32)
                }
            case .loaded:
                VStack() {
                    
                    // title
                    HStack {
                        Text("All requests")
                            .foregroundColor(.white)
                            .font(.asket(size: 32))
                        
                        Spacer()
                        
                        Button {
                            viewModel.fetchAllFlightsFor(user: AppService.shared.user.value!.uid)
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .scaledToFit()
                        }

                    }
                    
                    Spacer()
                    
                    ZStack {
                        if viewModel.allFlightsRequest.isEmpty {
                            
                            Spacer()
                            Text("No flight request")
                                .font(.asket(size: 28))
                                .foregroundColor(Color("subtitle.gray"))
                            Spacer()
                            
                        } else {
                            ScrollView(showsIndicators: false) {
                                
                                VStack {
                                    if !viewModel.upcomingFlights.isEmpty {
                                        HStack {
                                            
                                            Button(action: {
                                                withAnimation(.default){
                                                    showUpcomingFlights.toggle()
                                                }
                                            }, label: {
                                                HStack(spacing: 12) {
                                                    
                                                    Text("Upcoming flights")
                                                        .foregroundColor(.white)
                                                        .font(.asket(size: 20))
                                                    
                                                    
                                                    Image(systemName: showUpcomingFlights ? "chevron.down" : "chevron.up")
                                                        .resizable()
                                                        .foregroundColor(.white)
                                                        .frame(width: 10, height: 10)
                                                        .scaledToFit()
                                                }
                                                .animation(.none, value: showUpcomingFlights)
                                            })
                                            
                                            Spacer()
                                        }
                                        
                                        if showUpcomingFlights {
                                            ForEach(viewModel.upcomingFlights, id: \.self) { flightRequest in
                                                VStack(spacing: 12) {
                                                    
                                                    FlightRequestCardView(
                                                        flightRequest: flightRequest,
                                                        viewModel: viewModel
                                                    )
                                                    
                                                    if flightRequest != viewModel.upcomingFlights.last! {
                                                        Color("accent.blue")
                                                            .frame(height: 1)
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                    
                                    if !viewModel.completedFlights.isEmpty {
                                        HStack {
                                            Button(action: {
                                                withAnimation(.default){
                                                    showCompletedFlights.toggle()
                                                }
                                            }, label: {
                                                HStack(spacing: 12) {
                                                    
                                                    Text("Completed flights")
                                                        .foregroundColor(.white)
                                                        .font(.asket(size: 20))
                                                    
                                                    
                                                    Image(systemName: showCompletedFlights ? "chevron.down" : "chevron.up")
                                                        .resizable()
                                                        .foregroundColor(.white)
                                                        .frame(width: 10, height: 10)
                                                        .scaledToFit()
                                                }
                                                .animation(.none, value: showCompletedFlights)
                                            })
                                            
                                            Spacer()
                                        }
                                    }
                                    
                                    if !viewModel.completedFlights.isEmpty && showCompletedFlights {
                                        ForEach(viewModel.completedFlights, id: \.self) { flightRequest in
                                            VStack(spacing: 12) {
                                                
                                                FlightRequestCardView(
                                                    flightRequest: flightRequest,
                                                    viewModel: viewModel
                                                )
                                                
                                                if flightRequest != viewModel.completedFlights.last! {
                                                    Color("accent.blue")
                                                        .frame(height: 1)
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                                .padding(.bottom, 70)
                                .padding(.bottom, UIScreen.main.bounds.height / 11.3)
                            }
                        }
                        
                        VStack {
                            
                            Spacer()
                            
                            Button (action: {
                                AppService.shared.screenIndex.value = 0
                                viewModel.clearData()
                                navigation.push(InfoRequestView(viewModel: viewModel).asDestination(), animated: true)
                            }, label: {
                                ZStack {
                                    Color("accent.blue")
                                        .cornerRadius(12)
                                        .frame(height: 60)
                                    
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20)
                                            .scaledToFit()

                                        Text("New request")
                                            .foregroundColor(.white)
                                            .font(.asket(size: 24))
                                        
                                    }
                                    .padding(.vertical, 10)
                                }
                                .padding(.bottom, 50)
                            })
                        }
                        
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                }
            case .failure:
                Button {
                    viewModel.fetchAllFlightsFor(user: AppService.shared.user.value!.uid)
                } label: {
                    Text("Retry")
                        .foregroundColor(.white)
                        .font(.asket(size: 32))
                }
                
            }
            
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
        .bottomSheet(
            bottomSheetPosition: $viewModel.shouldDeleteUpcomingFlight,
            switchablePositions: [.relative(0.5)]) {
                VStack {
                    Text("You are about to delete an upcoming flight request!")
                        .font(.asket(size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("By continuing you will also cancel it.")
                        .font(.asket(size: 16))
                        .foregroundColor(Color("subtitle.gray"))
                    
                    
                    Button (action: {
                        viewModel.deleteFlightRequest(ID: viewModel.flightIDToBeDeleted)
                        viewModel.shouldDeleteUpcomingFlight = .hidden
                    }, label: {
                        ZStack {
                            Color("accent.blue")
                                .cornerRadius(12)
                                .frame(height: 60)
                            
                            HStack {
                                Text("Continue")
                                    .foregroundColor(.white)
                                    .font(.asket(size: 18))
                            }
                            .padding(.vertical, 10)
                        }
                    })
                    .padding(.top, 10)
                    
                    Button (action: {
                        viewModel.shouldDeleteUpcomingFlight = .hidden
                    }, label: {
                        ZStack {
                            Color("red")
                                .cornerRadius(12)
                                .frame(height: 60)
                            
                            HStack {
                                Text("Cancel")
                                    .foregroundColor(Color("background.first"))
                                    .font(.asket(size: 18))
                            }
                            .padding(.vertical, 10)
                        }
                    })

                    
                }
                .padding(.horizontal, 20)
            }
            .customBackground(content: {
                Color("background.first")
            })
            .enableSwipeToDismiss(true)
            .enableTapToDismiss(true)
    }
}



struct AllFlightRequestView_Previews: PreviewProvider {
    static var requestViewModel: RequestViewModel {
        let requestViewModel2 = RequestViewModel()
        requestViewModel2.allFlightsRequest = Array(
            repeating: RequestFormModel(
                firstName: "dsad",
                lastName: "dsadas",
                CNP: "3123124141",
                birthday: Date(),
                currentLocation: CLLocationCoordinate2D(),
                serialNumber: "123d12adsd12",
                droneType: .agricultural,
                takeoffTime: Date(),
                landingTime: Date() + 3600,
                flightLocation: CLLocationCoordinate2D(),
                responseModel: ResponseModel(
                    response: .accepted,
                    ID: "12312",
                    reason: "31EAS"
                )
            ),
            count: 20
        ) + Array(
            repeating: RequestFormModel(
                firstName: "dsad",
                lastName: "dsadas",
                CNP: "3123124141",
                birthday: Date(),
                currentLocation: CLLocationCoordinate2D(),
                serialNumber: "123d12adsd12",
                droneType: .agricultural,
                takeoffTime: Date(),
                landingTime: Date(),
                flightLocation: CLLocationCoordinate2D(),
                flightDate: Date() + TimeInterval(Int.random(in: 1000000...2000000000)),
                responseModel: ResponseModel(
                    response: .accepted,
                    ID: "12312",
                    reason: "31EAS"
                )
            ),
            count: 20
        )
        return requestViewModel2
    }
    static var previews: some View {
        NavigationView {
            AllFlightRequestView(viewModel: requestViewModel)
        }
    }
}
