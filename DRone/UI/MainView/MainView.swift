//
//  MainView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 07.08.2023.
//

import SwiftUI
import LottieSwiftUI

struct MainView: View {
    @EnvironmentObject private var navigation: Navigation
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
            ZStack{
                
                
                HomeView(
                    viewModel: HomeViewModel(isShowingAsChild: false)                    
                )
                .opacity(viewModel.selectedTab == .home ? 1 : 0)
                .environmentObject(navigation)
                
                
                AllFlightRequestView(viewModel: RequestViewModel())
                    .opacity(viewModel.selectedTab == .request ? 1 : 0)
                
                GoogleMapsView(viewModel: GoogleMapsViewModel())
                    .opacity(viewModel.selectedTab == .map ? 1 : 0)
                
                SettingView(viewModel: SettingsViewModel())
                    .opacity(viewModel.selectedTab == .settings ? 1 : 0)
                
                VStack {
                    Spacer()
                    TabBar()
                }
                .ignoresSafeArea()
            }
            .overlay(viewModel.shouldDisplayLocationModal != .hidden ? Color.gray.opacity(0.7).ignoresSafeArea() : Color.clear.ignoresSafeArea())
            .disabled(viewModel.shouldDisplayLocationModal != .hidden)
            .bottomSheet(
                bottomSheetPosition: $viewModel.shouldDisplayLocationModal,
                switchablePositions: [.relativeTop(0.6)]) {
                    VStack {
                        
                        Text("No location found!")
                            .foregroundColor(Color("red"))
                            .font(.asket(size: 32))
                        
                        
                        LottieView(name: "NoLocation")
                            .lottieLoopMode(.autoReverse)
                            .frame(width: 200, height: 200)
                        
                        Text("Please enable location in order to use the app!")
                            .foregroundColor(.white)
                            .font(.asket(size: 20))
                        
                        Button {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        } label: {
                            
                            Text("Go to settings")
                                .foregroundColor(.white)
                                .font(.asket(size: 16))
                                .padding(10)
                                .background(Color("accent.blue"))
                                .cornerRadius(12)
                        }

                    }
                }
        
            // network
            .overlay(viewModel.isConnectedToNetwork != .hidden ? Color.gray.opacity(0.7).ignoresSafeArea() : Color.clear.ignoresSafeArea())
            .disabled(viewModel.isConnectedToNetwork != .hidden)
            .bottomSheet(
                bottomSheetPosition: $viewModel.isConnectedToNetwork,
                switchablePositions: [.relativeTop(0.6)]) {
                    VStack {
                        
                        Text("No connection found!")
                            .foregroundColor(Color("red"))
                            .font(.asket(size: 32))
                        
                        
                        LottieView(name: "NoInternet")
                            .lottieLoopMode(.autoReverse)
                            .frame(width: 200, height: 200)
                        
                        Text("Please turn on mobile data / Wi-Fi in order to use the app!")
                            .foregroundColor(.white)
                            .font(.asket(size: 20))
                        
                        Button {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        } label: {
                            
                            Text("Go to settings")
                                .foregroundColor(.white)
                                .font(.asket(size: 16))
                                .padding(10)
                                .background(Color("accent.blue"))
                                .cornerRadius(12)
                        }

                    }
                }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
