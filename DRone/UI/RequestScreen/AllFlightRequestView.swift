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
            
            // title
            HStack {
                Text("All requests")
                    .foregroundColor(.white)
                    .font(.abel(size: 40))
                
                Spacer()
                
                
                NavigationLink (
                    destination:
                    InfoRequestInfo(viewModel: viewModel)
                        .navigationBarBackButtonHidden(true)
                , isActive: $isNavigationLinkShown,
            label: {
                    ZStack {
                        Color("accent.blue")
                            .cornerRadius(20)
                            .frame(width: 100, height: 40)
                        
                        HStack {
                            Text("New request")
                                .foregroundColor(.white)
                                .font(.abel(size: 12))
                            
                            Image(systemName: "chevron.right")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(width: 10, height: 10)
                                .scaledToFit()
                        }
                    }
                })
                .simultaneousGesture(
                    TapGesture()
                        .onEnded({ _ in
                            AppService.shared.screenIndex.value = 0
                            viewModel.clearData()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                isNavigationLinkShown = true
                            }
                        }))

            }
            
            
            ScrollView(showsIndicators: false) {
                ForEach(viewModel.allFlightsRequest, id: \.self) { flightRequest in
                    VStack(spacing: 12) {
                        
                        NavigationLink {
                            RequestDetailsView(viewModel: RequestDetailsViewModel(formModel: flightRequest))
                        } label: {
                            
                            
                            
                            HStack(spacing: 23) {
                                
                                // request state
                                VStack(spacing: 2) {
                                    
                                    Group {
                                        switch flightRequest.requestState {
                                        case .accepted:
                                            Circle()
                                                .fill(Color("green"))
                                        case .rejected:
                                            Circle()
                                                .fill(Color("red"))
                                        case .pending:
                                            Circle()
                                                .fill(Color("accent.blue"))
                                        }
                                    }
                                    .frame(width: 14, height: 14)
                                    
                                    Text(flightRequest.requestState.rawValue)
                                        .foregroundColor(.white)
                                        .font(.abel(size: 12))
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("Calea Victoriei, Sectorul 6,Bucharest")
                                        .foregroundColor(.white)
                                        .font(.abel(size: 18))
                                    
                                    // time interval
                                    HStack {
                                        Text(dateFormatter.string(from: flightRequest.dateRegistered))
                                            .foregroundColor(.white)
                                            .font(.abel(size: 18))
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 12) {
                                            
                                            Text(hourFormatter.string(from: flightRequest.takeoffTime))
                                                .foregroundColor(.white)
                                                .font(.abel(size: 18))
                                            
                                            Image(systemName: "arrow.right")
                                                .resizable()
                                                .foregroundColor(.white)
                                                .frame(width: 11, height: 11)
                                                .scaledToFit()
                                            
                                            Text(hourFormatter.string(from: flightRequest.landingTime))
                                                .foregroundColor(.white)
                                                .font(.abel(size: 18))
                                        }
                                        
                                    }
                                    
                                }
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .frame(width: 16, height: 16)
                                    .scaledToFit()
                            }
                        }
                        
                        Color("accent.blue")
                            .frame(height: 1)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
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
                droneType: .agrar,
                takeoffTime: Date(),
                landingTime: Date() + 3600,
                flightLocation: CLLocationCoordinate2D(),
                requestState: .rejected
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
