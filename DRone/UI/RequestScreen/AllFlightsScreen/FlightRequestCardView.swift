//
//  FlightRequestCardView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 21.08.2023.
//

import SwiftUI
import CoreLocation

struct FlightRequestCardView: View {
    
    @EnvironmentObject private var navigation: Navigation
    
    let flightRequest: RequestFormModel
    let completedFlight: Bool
    
    private var hourFormatter: DateFormatter {
        let hrFmt = DateFormatter()
        hrFmt.dateFormat = "HH:mm"
        return hrFmt
    }
    
    private var dateFormatter: DateFormatter {
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "dd / MM / yyyy"
        return dateFmt
    }
    
    init(flightRequest: RequestFormModel) {
        self.flightRequest = flightRequest
        self.completedFlight = flightRequest.flightDate < Date()
    }
    
    var body: some View {
        Button {
            navigation.push(RequestDetailsView(viewModel: RequestDetailsViewModel(formModel: flightRequest)).asDestination(), animated: true)
        } label: {
            
            ZStack {
                HStack(spacing: 24) {
                    
                    // request state
                    VStack(spacing: 2) {
                        
                        Group {
                            switch flightRequest.responseModel.response {
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
                        
                        Text(flightRequest.responseModel.response.rawValue)
                            .foregroundColor(.white)
                            .font(.abel(size: 12))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("\(flightRequest.flightAdress.secondaryAdress), \(flightRequest.flightAdress.mainAdress)")
                            .foregroundColor(.white)
                            .font(.abel(size: 18))
                        
                        // time interval
                        HStack {
                            Text(dateFormatter.string(from: flightRequest.flightDate))
                                .foregroundColor(.white)
                                .font(.abel(size: 16))
                            
                            Spacer()
                            
                            HStack(spacing: 12) {
                                
                                Text(hourFormatter.string(from: flightRequest.takeoffTime))
                                    .foregroundColor(.white)
                                    .font(.abel(size: 16))
                                
                                Image(systemName: "arrow.right")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 11, height: 11)
                                    .scaledToFit()
                                
                                Text(hourFormatter.string(from: flightRequest.landingTime))
                                    .foregroundColor(.white)
                                    .font(.abel(size: 16))
                            }
                            
                        }
                        
                    }
                    Image(systemName: "chevron.right")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color("gray.background").opacity(0.4))
                        .frame(width: 16, height: 16)
                        .scaledToFit()
                }
                .padding(.leading, 5)
                .overlay(completedFlight ?  Color("gray.background").opacity(0.4) : Color.clear)
                
                if completedFlight {
                    HStack {
                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 16, height: 16)
                            .scaledToFit()
                    }
                    .padding(.trailing, 10)
                }
            }
        }
    }
}

struct FlightRequestCardView_Previews: PreviewProvider {
    static var previews: some View {
        FlightRequestCardView(flightRequest: RequestFormModel(
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
        ))
    }
}
