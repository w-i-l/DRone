//
//  RequestDetailsView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 16.08.2023.
//

import SwiftUI
import CoreLocation

struct RequestDetailsView: View {
    
    let formModel: RequestFormModel
    
    var hourFormatter = DateFormatter()
    
    var body: some View {
        VStack() {
            ScrollView(showsIndicators: false) {
                Text("Flight request with ID: A83D4BB1")
                    .foregroundColor(.white)
                    .font(.abel(size: 32))
                
                Image("accepted.image")
                    .resizable()
                    .frame(width: 125, height: 125)
                
                Text("Accepted")
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
                    ("Personal information", ("Full name", "\(formModel.firstName) \(formModel.lastName)"),
                     ("Personal number identification", formModel.CNP)),
                    ("Drone information", ("Serial number", formModel.serialNumber), ("Drone type", formModel.droneType.associatedValues.type)),
                    ("Flight information", ("Takeoff time", hourFormatter.string(from:formModel.takeoffTime)), ("Landing time", hourFormatter.string(from:formModel.landingTime)))
                ], id: \.0) { item in
                    VStack(alignment: .leading, spacing: 0) {
                        Text(item.0)
                            .foregroundColor(Color("accent.blue"))
                            .font(.abel(size: 16))
                        
                        HStack {
                            Text(item.1.0)
                                .foregroundColor(.white)
                            .font(.abel(size: 16))
                            
                            Spacer()
                            
                            Text(item.1.1)
                                .foregroundColor(.white)
                            .font(.abel(size: 16))
                        }
                        .padding(.top, 7)
                        
                        HStack {
                            Text(item.2.0)
                                .foregroundColor(.white)
                            .font(.abel(size: 16))
                            
                            Spacer()
                            
                            Text(item.2.1)
                                .foregroundColor(.white)
                            .font(.abel(size: 16))
                        }
                        .padding(.top, 5)
                        
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
    
    init(formModel: RequestFormModel) {
        hourFormatter.dateFormat = "HH:mm"
        self.formModel = formModel
    }
}

struct RequestDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RequestDetailsView(formModel: RequestFormModel(
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
        ))
    }
}
