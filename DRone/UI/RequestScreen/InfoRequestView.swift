
//
//  InfoRequestView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 10.08.2023.
//

import SwiftUI
import LottieSwiftUI

struct InfoRequestView: View {
    
    @ObservedObject var viewModel: RequestViewModel
    @EnvironmentObject private var navigation: Navigation
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        VStack {
            
            BackButton(text: "All requests")
            
            GeometryReader { proxy in
                ScrollView {
                    VStack {
                        
                        
                        // info
                        VStack(alignment: .leading) {
                            // request a flight
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("REQUEST")
                                        .font(.asket(size: 32))
                                        .foregroundColor(.white)
                                    
                                    Text("a flight")
                                        .font(.asket(size: 24))
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                            }
                            
                            Spacer()
                            
                            // steps
                            VStack(alignment: .leading, spacing: 24) {
                                ForEach([
                                    (1, "Fill the form"),
                                    (2, "Wait for confirmation"),
                                    (3, "You are ready to go!")
                                ], id: \.1) { item in
                                    
                                    VStack(alignment: .leading, spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(Color(red: 0.851, green: 0.851, blue: 0.851))
                                                .frame(width: 40, height: 40)
                                            
                                            Text("\(item.0)")
                                                .foregroundColor(Color("background.first"))
                                                .font(.asket(size: 28))
                                        }
                                        
                                        Text(item.1)
                                            .foregroundColor(.white)
                                            .font(.asket(size: 24))
                                    }
                                    
                                }
                            }
                            .padding(.vertical, 40)
                            
                            // start button
                            HStack {
                                Spacer()
                                
                                Button (action: {
                                    viewModel.clearData()
                                    viewModel.syncDataWithCurrentUserInfo()
                                    
                                    navigation.push(RequestFormView(viewModel: viewModel).asDestination(), animated: true)
                                }, label: {
                                    ZStack {
                                        Color("accent.blue")
                                            .cornerRadius(12)
                                            .frame(height: 60)
                                        
                                        HStack {
                                            Text("Start")
                                                .foregroundColor(.white)
                                                .font(.asket(size: 24))
                                        }
                                        .padding(.vertical, 10)
                                    }
                                })
                                
                            }
                            
                        }
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        .background(
                            // drone Image
                            VStack(alignment: .trailing) {
                                HStack {
                                    Spacer()

//                                    Image("drone.image")
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
//                                        .frame(width: UIScreen.main.bounds.width / 1)
//                                        .offset(y: -60)
//                                        .scaledToFit()
                                    LottieView(name: "PilotingDrone")
                                        .lottieLoopMode(.autoReverse)
                                        .frame(width: 350, height: 350)
                                        .offset(x: 50)
                                }

                                Spacer()
                            }
                                .padding(.horizontal, 0)
                                .frame(maxWidth: .infinity)
                        )
                        
                    }
                    .frame(minHeight: proxy.size.height)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
//        .padding(.bottom, UIScreen.main.bounds.height / 11.3)
    }
}

struct InfoPersonal_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ZStack{
                InfoRequestView(viewModel: RequestViewModel())
                
                VStack {
                    Spacer()
                    TabBar()
                }
                .ignoresSafeArea()
            }
        }
        .navigationBarHidden(true)
    }
}

