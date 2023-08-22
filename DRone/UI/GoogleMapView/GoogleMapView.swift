//
//  MapBridge.swift
//  DRone
//
//  Created by Mihai Ocnaru on 22.08.2023.
//


import SwiftUI
import GoogleMaps



struct GoogleMapsView: View {
    
    @StateObject var viewModel: GoogleMapsViewModel
    
    @State private var showTerrainOptions: Bool = false
    
    var body: some View {
        ZStack {
            viewModel.map
                .ignoresSafeArea()
            
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
                                                .font(.abel(size: 12))
                                        }
                                    })
                                }
                            }
                            .padding(10)
                            .background(Color.white)
                            .offset(y: 116)
                        }
                        
                        // control buttons
                        ZStack {
                            Color.white
                                .cornerRadius(12)
                                .frame(width: 50)
                                .frame(maxHeight: 110)
                            
                            
                            VStack(spacing: 16) {
                                
                                Button {
                                    
                                    viewModel.goToCurrentLocation()
                                } label: {
                                    Image(systemName: "paperplane")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color("background.first"))
                                        .frame(width: 18, height: 18)
                                        .scaledToFit()
                                }
                                
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
                                
                                
                            }
                            .padding(.vertical, 10)
                            
                            
                        }
                    }
                }
                .frame(maxHeight: 110)
                Spacer()
            }
            .padding(20)
            .shadow(radius: 10)
        }
    }
}

struct GoogleMapsView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleMapsView(viewModel: GoogleMapsViewModel())
        
    }
}
