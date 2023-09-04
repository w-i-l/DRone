//
//  FlightRequestCardView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 21.08.2023.
//

import SwiftUI
import CoreLocation
import BottomSheet

struct FlightRequestCardView: View {
    
    @EnvironmentObject private var navigation: Navigation
    @ObservedObject var viewModel: RequestViewModel
    
    @State private var offset: CGFloat = .zero
    @State private var cardOffset: CGFloat = .zero
    
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
    
    init(flightRequest: RequestFormModel, viewModel: RequestViewModel) {
        self.flightRequest = flightRequest
        self.completedFlight = flightRequest.flightDate < Date()
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        ZStack {
            
            Color("red")
                .frame(height: 60)
            
            HStack {
            
                Spacer()
                
                Image(systemName: "trash.fill")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color("background.first"))
                    .frame(width: max(20, -offset * 0.2), height: max(20, -offset * 0.2))
                    .aspectRatio(contentMode: .fit)
                
            }
            .padding(.trailing, 20)
                
            Color("background.first")
                .frame(height: 60)
                .offset(x: offset)
            
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
                                .font(.asket(size: 12))
                        }
                        
                        VStack(alignment: .leading) {
                            Text("\(flightRequest.flightAdress.secondaryAdress), \(flightRequest.flightAdress.mainAdress)".limitLettersFormattedString(limit: 30))
                                .foregroundColor(.white)
                                .font(.asket(size: 16))
                                .multilineTextAlignment(.leading)
                                .lineLimit(1)
                            
                            // time interval
                            HStack {
                                Text(dateFormatter.string(from: flightRequest.flightDate))
                                    .foregroundColor(.white)
                                    .font(.asket(size: 14))
                                
                                Spacer()
                                
                                HStack(spacing: 12) {
                                    
                                    Text(hourFormatter.string(from: flightRequest.takeoffTime))
                                        .foregroundColor(.white)
                                        .font(.asket(size: 14))
                                        .lineLimit(1)
                                    
                                    Image(systemName: "arrow.right")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .frame(width: 11, height: 11)
                                        .scaledToFit()
                                    
                                    Text(hourFormatter.string(from: flightRequest.landingTime))
                                        .foregroundColor(.white)
                                        .font(.asket(size: 14))
                                        .lineLimit(1)
                                }
                                
                            }
                            
                        }
                        Image(systemName: "chevron.right")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(completedFlight ? Color("gray.background").opacity(0.4) : .white)
                            .frame(width: 12, height: 12)
                            .scaledToFit()
                            .padding(.trailing, 10)
                    }
                    .padding(.vertical, 10)
                    .padding(.leading, 5)
                    .overlay(completedFlight ?  Color("gray.background").opacity(0.4) : Color.clear)
                    
                    if completedFlight {
                        HStack {
                            Spacer()
                            Image(systemName: "chevron.right")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(width: 12, height: 12)
                                .scaledToFit()
                        }
                        .padding(.trailing, 10)
                    }
                }
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged({ drag in
                            if drag.translation.width < 0 {
                                offset = max(drag.translation.width, -150)
                            }
                        })
                        .onEnded({ _ in
                            withAnimation(.default) {
                                if offset <= -100 && completedFlight == true {
                                    viewModel.deleteFlightRequest(ID: self.flightRequest.responseModel.ID)
                                    cardOffset = -UIScreen.main.bounds.width
                                } else if completedFlight == false {
                                    viewModel.shouldDeleteUpcomingFlight = .relative(0.5)
                                    viewModel.flightIDToBeDeleted = self.flightRequest.responseModel.ID
                                }
                                offset = .zero
                            }
                        })
                )
            }
        }
        .offset(x: cardOffset)
    }
}

struct FlightRequestCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
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
                flightDate: Date() + 1321312312,
                responseModel: ResponseModel(
                    response: .accepted,
                    ID: "12312",
                    reason: "31EAS"
                )
            ),
             viewModel: RequestViewModel()
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}
