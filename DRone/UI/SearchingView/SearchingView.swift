//
//  SearchingView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 09.08.2023.
//

import SwiftUI
import CoreLocation

struct SearchingView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: SearchingViewModel
    
    @State private var textFieldDidReturned: Bool = false
    
    var body: some View {
        
        
        
        VStack {
            
            HStack {
                // searching bar
                ZStack {
                    
                    Color.white
                        .cornerRadius(12)
                        .frame(height: 45)
                    
                    HStack {
                        
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color("accent.blue"))
                            .frame(width: 24, height: 24)
                            .scaledToFit()
                        
                        
                        TextField("", text: $viewModel.textSearched, onCommit: {
                            viewModel.predictedLocations = []
                        })
                            .foregroundColor(Color("background.first"))
                            .font(.abel(size: 20))
                            .autocorrectionDisabled(true)
                            .keyboardType(.asciiCapable)
                            .autocapitalization(.words)
                            .placeholder(when: viewModel.textSearched.isEmpty) {
                                Text("Search for a location")
                                    .font(.abel(size: 20))
                                    .foregroundColor(Color("subtitle.gray"))
                            }
                            .onTapGesture {
                                textFieldDidReturned = false
                            }
                        
                        
                        Spacer()
                        
                        Button {
                            viewModel.textSearched = ""
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color("subtitle.gray"))
                                .frame(width: 16, height: 16)
                                .scaledToFit()
                                .opacity(viewModel.textSearched.isEmpty ? 0 : 1)
                                .animation(.easeInOut, value: viewModel.textSearched)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .frame(height: 45)
                    
                }
                
                if viewModel.showCurrentLocation {
                    Button {
                        
                        guard let location = LocationService.shared.locationManager.location?.coordinate else {
                            print("No location could be found!")
                            return
                        }
                        
                        viewModel.matchLocationWithCurrentLocation(location: location)
                        
                        viewModel.predictedLocations = []
                        dismiss()
                    } label: {
                        Image(systemName: "paperplane")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .scaledToFit()
                    }
                }
            }
            
            if !viewModel.predictedLocations.isEmpty {
                // results
                VStack(alignment: .leading) {
                    ScrollView(showsIndicators: false) {
                        ForEach(viewModel.predictedLocations, id:\.addressID) { item in
                            Button {
                                viewModel.selectedAddress = item
                                viewModel.textSearched = item.addressName
                                viewModel.updateLocation()
                                
                                textFieldDidReturned = true
                                viewModel.predictedLocations = []
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                
                                if viewModel.showCurrentLocation {
                                    dismiss()
                                }
                            } label: {
                                HStack(spacing: 15) {
                                    
                                    Image(systemName: "mappin.circle.fill")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color("subtitle.gray"))
                                        .frame(width: 14, height: 14)
                                        .scaledToFit()
                                    
                                    
                                    Text(item.addressName)
                                        .foregroundColor(Color("background.first"))
                                        .font(.abel(size: 18))
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                }
                                .padding(10)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(
                            Color.white
                                .cornerRadius(12)
                        )
                    }
                }
            }
        }
        .onChange(of: viewModel.textSearched) { newValue in
            if !textFieldDidReturned {
                viewModel.searchForNearbyLocations()
            }
        }
        
    }
}

struct SearchingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            SearchingView(viewModel: SearchingViewModel(adressToFetchLocation: .constant(CLLocationCoordinate2D())))
                .frame(height: 50)
                .padding(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
        )
    }
}
