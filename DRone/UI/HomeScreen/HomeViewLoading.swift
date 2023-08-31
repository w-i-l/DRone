//
//  HomeScreenShimmer.swift
//  DRone
//
//  Created by Mihai Ocnaru on 08.08.2023.
//

import SwiftUI

struct HomeViewLoading: View {
    
    private let width = UIScreen.main.bounds.width
    private let height = UIScreen.main.bounds.height
    
    let isShowingAsChild: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                
                // current location
                HStack {
                    VStack(alignment: .leading) {
                        CardShimmer()
                            .frame(width: width / 2, height: 30)
                        CardShimmer()
                            .frame(width: width / 2.3, height: 18)
                    }
                    
                    Spacer()
                }
                
                // weather
                HStack {
                    VStack(alignment: .leading) {
                        CardShimmer()
                            .frame(width: width / 2.5, height: 50)
                        CardShimmer()
                            .frame(width: width / 4, height: 18)
                    }
                    
                    Spacer()

                    ProgressView()
                        .accentColor(.white)
                        .frame(width: 100, height: 100)
                        .scaleEffect(3)
                    
                }
                .padding(.top, 32)
                
                // weather verdict
                HStack {
                    ZStack(alignment: .leading) {
                        CardShimmer()
                            .frame(height: UIScreen.main.bounds.height / 10)
                            .cornerRadius(12)
                        
                        Text("Fetching data...")
                            .foregroundColor(Color("background.first"))
                            .font(.asket(size: 32))
                            .padding(.leading, 20)
                    }
                }
                .padding(.top, 32)
                
                // main weather info
                HStack {
                    ZStack {
                        CardShimmer()
                            .cornerRadius(12)
                        
                        HStack {
                            ForEach([
                                ("sunset.fill", "Sunset", ""),
                                ("cloud.rain.fill", "Prec. prob.", "\("")"),
                                ("flag.fill", "Wind speed", "\("")")
                            ], id: \.0) { item in
                                Spacer()
                                VStack(spacing: 0) {
                                    Image(systemName: item.0)
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 40)
                                        .scaledToFit()
                                    
                                    Text(item.1)
                                        .font(.asket(size: 12))
                                        .foregroundColor(.white)
                                        .padding(.top, 10)
                                        .padding(.bottom, 3)
                                    
                                }
                                Spacer()
                            }
                        }
                        .padding(.vertical, 10)
                    }
                        
                }
                .frame(height: UIScreen.main.bounds.height / 6.7)
                .padding(.top, 30)
                
                // scodary weather infos
                HStack(spacing: 15) {
                    ForEach( [
                        ("Wind \ndirection", ""),
                        ("Satellites \navailible", ""),
                        ("Visibility", "")
                    ], id: \.0) { item in
                        
                        //
                        ZStack {
                            
                            CardShimmer()
                                .frame(height: 100)
                                .cornerRadius(12)
                            
                            VStack() {
                                
                                Spacer()
                                
                                Text(item.0)
                                    .font(.asket(size: 14))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                Spacer()
                                
                                Text(item.1)
                                    .font(.asket(size: 24))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 10)
                            }
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height / 8)
                .padding(.top, 20)
                
                if !isShowingAsChild {
                    // see more button
                    Button {
                        
                    } label: {
                        ZStack(alignment: .trailing) {
                            Color("gray.background")
                                .cornerRadius(12)
                            HStack {
                                
                                Text("See more infos ")
                                    .font(.asket(size: 20))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 12)
                                
                                
                                
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .frame(width: 12, height: 12)
                                    .padding(.trailing, 20)
                                    .scaledToFit()
                            }
                            
                        }
                    }
                    .frame(width: 200)
                    .frame(height: 55)
                    .padding(.top, 30)
                    .disabled(true)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
        .navigationBarHidden(true)
    }
}

struct HomeViewShimmer_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewLoading(isShowingAsChild: false)
    }
}
