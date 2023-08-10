//
//  HomeViewFailed.swift
//  DRone
//
//  Created by Mihai Ocnaru on 09.08.2023.
//

import SwiftUI

struct HomeViewFailed: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // current location
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Unknown location")
                                .font(.abel(size: 32))
                                .foregroundColor(.white)
                            
                            Text("")
                                .font(.abel(size: 20))
                                .foregroundColor(Color("subtitle.gray"))
                        }
                        
                        Spacer()
                        
                    }
                    
                    // current temperature
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("º C")
                                .font(.abel(size: 64))
                                .foregroundColor(.white)
                            
                            Text("Couldn't fetch")
                                .font(.abel(size: 20))
                                .foregroundColor(Color("subtitle.gray"))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "photo")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                    .padding(.top, 32)
                    
                    // flight verdict
                    ZStack(alignment: .leading) {
                        Color.gray
                        .cornerRadius(12)
                        
                        Text("Can't determine")
                            .font(.abel(size: 32))
                            .foregroundColor(Color("background.first"))
                            .padding(.leading, 20)
                    }
                    .frame(height: UIScreen.main.bounds.height / 10)
                    .padding(.top, 32)
                    
                    // main weather infos
                    ZStack {
                        Color("gray.background")
                            .cornerRadius(12)
                        
                        HStack {
                            ForEach([
                                ("sunset", "Sunset", "N/A"),
                                ("cloud.rain", "Prec. prob.", "N/A"),
                                ("flag", "Wind speed", "N/A")
                            ], id: \.0) { item in
                                Spacer()
                                VStack {
                                    Image(systemName: item.0)
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 40)
                                    
                                    Text(item.1)
                                        .font(.abel(size: 16))
                                        .foregroundColor(.white)
                                    
                                    Text(item.2)
                                        .font(.abel(size: 20))
                                        .foregroundColor(.white)
                                }
                                Spacer()
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .frame(height: UIScreen.main.bounds.height / 6.7)
                    .padding(.top, 30)
                    
                    // scodary weather infos
                    HStack(spacing: 15) {
                        ForEach( [
                            ("Wind \ndirection", "N/A"),
                            ("Satellites \navailible", "N/A"),
                            ("Visibility", "N/A")
                        ], id: \.0) { item in
                            
                            //
                            ZStack {
                                
                                Color("gray.background")
                                    .frame(height: 100)
                                    .cornerRadius(12)
                                
                                VStack() {
                                    
                                    Spacer()
                                    
                                    Text(item.0)
                                        .font(.abel(size: 16))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                    
                                    Spacer()
                                    
                                    Text(item.1)
                                        .font(.abel(size: 24))
                                        .foregroundColor(.white)
                                        .padding(.bottom, 10)
                                }
                                
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.height / 8)
                    .padding(.top, 20)
                    
                    // see more button
                    Button {
                        viewModel.updateUI()
                    } label: {
                        ZStack(alignment: .trailing) {
                            Color("accent.blue")
                                .cornerRadius(12)
                            HStack {
                                
                                Text("Refresh")
                                    .font(.abel(size: 20))
                                    .foregroundColor(Color("background.first"))
                                    .padding(.vertical, 12)
                                
                                Image(systemName: "arrow.forward")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color("background.first"))
                                    .frame(width: 14, height: 14)
                                    .padding(.trailing, 20)
                            }
                            
                        }
                    }
                    .frame(width: 180)
                    .frame(height: 55)
                    .padding(.top, 30)
                    
                    
                    Spacer()
                    
                }
                .padding(.bottom, UIScreen.main.bounds.height / 11.3)
            }
            .padding([.horizontal, .bottom], 20)
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
        )
//        .refreshable {
//            if viewModel.fetchingState != .loading {
//                viewModel.updateUI()
//            }
//        }
        
        
    }
}

struct HomeViewFailed_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewFailed(viewModel: HomeViewModel())
    }
}
