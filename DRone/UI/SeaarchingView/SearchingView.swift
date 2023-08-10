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
    
    var body: some View {
        
        
        ScrollView(showsIndicators: false) {
            VStack {
                ZStack {
                    
                    Color.white
                        .cornerRadius(12)
                    HStack {
                        
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color("accent.blue"))
                            .frame(width: 24, height: 24)
                            .scaledToFit()
                        
                        TextField("Search for a location", text: $viewModel.textSearched)
                        .foregroundColor(Color("background.first"))
                        .font(.abel(size: 20))
                        
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
                    
                }
                VStack(alignment: .leading) {
                    ForEach(viewModel.predictedLocations, id:\.addressID) { item in
                        Button {
                            viewModel.selectedAddress = item
                            viewModel.textSearched = item.addressName
                            viewModel.updateLocation()
                        } label: {
                            HStack(spacing: 15) {
                                
                                Image(systemName: "mappin.circle.fill")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color("subtitle.gray"))
                                    .frame(width: 14, height: 14)
                                  
                                
                                Text(item.addressName)
                                    .foregroundColor(Color("background.first"))
                                    .font(.abel(size: 18))
                                
                                Spacer()
                            }
                            .padding(10)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .background(
                    Color.white
                        .cornerRadius(12)
                )
            }
        }
        .onChange(of: viewModel.textSearched) { newValue in
            print("D")
            viewModel.searchForNearbyLocations()
        }
//        .toolbar(.visible)
//        .toolbar {
//            ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
//                
//                Button {
//                    dismiss()
//                }
//            label: {
//                HStack(spacing: 14) {
//                    Image(systemName: "chevron.left")
//                        .resizable()
//                        .renderingMode(.template)
//                        .frame(width: 14, height: 14)
//                        .scaledToFit()
//                        .foregroundColor(.white)
//                    
//                    
//                    Text("Home")
//                        .font(.abel(size: 24))
//                        .foregroundColor(.white)
//                }
//            }}
//        }
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
