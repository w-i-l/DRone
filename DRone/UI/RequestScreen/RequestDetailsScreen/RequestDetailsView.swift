//
//  RequestDetailsView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 16.08.2023.
//

import SwiftUI
import CoreLocation
import AlertToast

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareSheet>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareSheet>) {
        // Update if needed
    }
}

struct RequestDetailsView: View {
    
    @StateObject var viewModel: RequestDetailsViewModel
    @EnvironmentObject private var navigation: Navigation
    
    @State private var presentAlert: Bool = false
    
    private var hourFormatter: DateFormatter {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }
    }
    
    var body: some View {
        VStack() {
            
            BackButton(text: "All requests", trailingItems: {
                Button {
                    navigation.presentModal(ShareSheet(activityItems: [viewModel.formModel.responseModel.ID]).asDestination(), animated: true) {
                        
                    } controllerConfig: { _ in
                        
                    }

                    
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .scaledToFit()
                }
                
            })
            
            ScrollView(showsIndicators: false) {

                VStack {
                    Text("Flight request with ID:")
                        .foregroundColor(.white)
                        .font(.abel(size: 32))
                    
                    Button {
                        UIPasteboard.general.string = viewModel.formModel.responseModel.ID
                        presentAlert = true
                    } label: {
                        Text(viewModel.formModel.responseModel.ID)
                            .foregroundColor(.blue)
                            .font(.abel(size: 32))
                    }

                }
                
                // request image
                Image(viewModel.formModel.responseModel.response == .accepted ? "accepted.image" : (viewModel.formModel.responseModel.response == .pending ? "waiting.image" : "rejected.image"))
                    .resizable()
                    .frame(width: 125, height: 125)
                    .scaledToFit()
                
                // request state
                Text(viewModel.formModel.responseModel.response.rawValue)
                    .foregroundColor(.white)
                    .font(.abel(size: 24))
                
                // reason
                if viewModel.formModel.responseModel.response == .rejected {
                    Text(viewModel.formModel.responseModel.reason)
                        .foregroundColor(.white)
                        .font(.abel(size: 16))
                }
                
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
        .toast(isPresenting: $presentAlert) {
            AlertToast(displayMode: .hud, type: .image("copy.icon", .green), title: "Copied")
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
            droneType: .agricultural,
            takeoffTime: Date(),
            landingTime: Date(),
            flightLocation: CLLocationCoordinate2D(),
            responseModel: ResponseModel(
                response: .accepted,
                ID: "3212",
                reason: "dsadsa"
            )
        )))
    }
}
