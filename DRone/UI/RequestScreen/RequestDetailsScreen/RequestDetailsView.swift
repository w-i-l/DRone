//
//  RequestDetailsView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 16.08.2023.
//

import SwiftUI
import CoreLocation

struct RequestDetailsView: View {
    
    @StateObject var viewModel: RequestDetailsViewModel
    
    private var hourFormatter: DateFormatter {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }
    }
    
    var body: some View {
        VStack() {
            
            BackButton(text: "All requests")
            
            ScrollView(showsIndicators: false) {
                Text("Flight request with ID: A83D4BB1")
                    .foregroundColor(.white)
                    .font(.abel(size: 32))
                
                Image(viewModel.formModel.requestState == .accepted ? "accepted.image" : (viewModel.formModel.requestState == .pending ? "waiting.image" : "rejected.image"))
                    .resizable()
                    .frame(width: 125, height: 125)
                
                Text(viewModel.formModel.requestState.rawValue)
                    .foregroundColor(.white)
                    .font(.abel(size: 24))
                
                HStack() {
                    Text("Your request information:")
                        .foregroundColor(.white)
                        .font(.abel(size: 24))
                Spacer()
                }
                .padding(.top, 32)
                
                
                
                ForEach([
                    ("Personal information", [
                        ("Full name", "\(viewModel.formModel.firstName) \(viewModel.formModel.lastName)"),
                        ("Personal number identification", viewModel.formModel.CNP)
                    ]),
                    ("Drone information", [
                        ("Serial number", viewModel.formModel.serialNumber),
                        ("Drone type", viewModel.formModel.droneType.associatedValues.type)
                    ]),
                    ("Flight information", [
                        ("Takeoff time", hourFormatter.string(from: viewModel.formModel.takeoffTime)),
                        ("Landing time", hourFormatter.string(from: viewModel.formModel.landingTime)),
                        ("Location", "\(viewModel.formModel.flightAdress.secondaryAdress), \(viewModel.formModel.flightAdress.mainAdress)")
                    ])
                ], id: \.0) { item in
                    VStack(alignment: .leading, spacing: 0) {
                        Text(item.0)
                            .foregroundColor(Color("accent.blue"))
                            .font(.abel(size: 16))
                        
                        ForEach(item.1, id: \.0) { tuple in
                            
                            
                            HStack {
                                Text(tuple.0)
                                    .foregroundColor(.white)
                                    .font(.abel(size: 16))
                                
                                Spacer()
                                
                                Text(tuple.1)
                                    .foregroundColor(.white)
                                    .font(.abel(size: 16))
                            }
                            .padding(.top, 7)
                        }
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                            .frame(height: 1)
                            .padding(.vertical, 10)
                    }
                }
                .padding(.top, 10)
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
    }
}

struct RequestDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RequestDetailsView(viewModel: RequestDetailsViewModel(formModel: RequestFormModel(
            firstName: "Mihai",
            lastName: "Ocnaru",
            CNP: "5031008450036",
            birthday: Date(),
            currentLocation: CLLocationCoordinate2D(),
            serialNumber: "F7D2K01",
            droneType: .agrar,
            takeoffTime: Date(),
            landingTime: Date(),
            flightLocation: CLLocationCoordinate2D()
        )))
    }
}
