//
//  MapBridge.swift
//  DRone
//
//  Created by Mihai Ocnaru on 22.08.2023.
//


import SwiftUI
import GoogleMaps
import BottomSheet


struct GoogleMapsView: View {
    
    @StateObject var viewModel: GoogleMapsViewModel
    
    @EnvironmentObject private var navigation: Navigation
    
    @State private var showTerrainOptions: Bool = false
    @State private var textFieldFocussed: Bool = false
    @State private var showInfoModal: Bool = false
    
    var body: some View {
        ZStack {
            viewModel.map
                .ignoresSafeArea()
                .simultaneousGesture (
                
                    TapGesture()
                        .onEnded({ _ in
                            dismissKeyboard()
                            
                            viewModel.searchingViewModel.predictedLocations = []
                            
                            if viewModel.bottomSheetPosition != .hidden {
                                viewModel.bottomSheetPosition = .hidden
                            }
                        })
                )

            VStack {
                
                HStack {
                    Spacer()
                    
                    HStack {
                       
                        // terain types
                        if showTerrainOptions {
                            VStack {
                                ForEach([
                                    "satellite",
                                    "terrain",
                                    "hybrid"
                                    
                                ], id: \.self) { mapType in
                                    
                                    Button (action: {
                                        viewModel.changeTerrainType(type: mapType)
                                        showTerrainOptions.toggle()
                                    }, label :{
                                        VStack {
                                            Image("map.\(mapType)")
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .scaledToFit()
                                            Text(mapType.capitalized)
                                                .foregroundColor(Color("background.first"))
                                                .font(.asket(size: 12))
                                        }
                                    })
                                }
                            }
                            .padding(10)
                            .background(Color.white.cornerRadius(12))
                            .offset(y: 116)
                        }
                        
                        // control buttons
                        ZStack {
                            Color.white
                                .cornerRadius(12)
                                .frame(width: 50)
                                .frame(maxHeight: 165)
                            
                            
                            VStack(spacing: 16) {
                                
                                Button {
                                    
                                    viewModel.goToCurrentLocation()
                                } label: {
                                    Image("current.location")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color("background.first"))
                                        .frame(width: 18, height: 18)
                                        .scaledToFit()
                                }
                                .padding(.top, 10)
                                
                                Color("gray.background")
                                    .frame(width: 50, height: 1)
                                
                                Button {
                                    
                                    showTerrainOptions.toggle()
                                } label: {
                                    Image(systemName: "map")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color("background.first"))
                                        .frame(width: 18, height: 18)
                                        .scaledToFit()
                                }
                                
                                Color("gray.background")
                                    .frame(width: 50, height: 1)
                                
                                Button {
                                    viewModel.bottomSheetPosition = .relativeTop(0.7)
            
                                } label: {
                                    Image(systemName: "info.circle")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color("background.first"))
                                        .frame(width: 18, height: 18)
                                        .scaledToFit()
                                }
                                .padding(.bottom, 10)
                                
                            }
                            .padding(10)
                        }
                    }
                }
                .frame(maxHeight: 110)
                Spacer()
            }
            .padding(20)
            .shadow(radius: 10)
            .padding(.top, 80)
            .onTapGesture {
                textFieldFocussed = false
            }
            
            VStack {
                SearchingView(viewModel: viewModel.searchingViewModel)
                    .onTapGesture {
                        textFieldFocussed = true
                    }
                    .onChange(of: viewModel.addressToFetchLocation!) { newValue in
                        viewModel.map.mapView.camera = GMSCameraPosition(
                            target: newValue,
                            zoom: 12
                        )
                        
                        textFieldFocussed = false
                    }
                    
                
                Spacer()
            }
            .padding(20)
        }
        .bottomSheet(
            bottomSheetPosition: $viewModel.bottomSheetPosition,
            switchablePositions: [.relativeTop(0.7)],
            content: {
                NoFlyZoneInfoModal()
            }
        )
        .customBackground(Color("background.first").ignoresSafeArea())
        .enableSwipeToDismiss()
        .enableTapToDismiss()
    }
}


struct GoogleMapsView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleMapsView(viewModel: GoogleMapsViewModel())
        
    }
}
