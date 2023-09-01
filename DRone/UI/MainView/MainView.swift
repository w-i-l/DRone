//
//  MainView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 07.08.2023.
//

import SwiftUI
import LottieSwiftUI

struct MainView: View {
     
    private let navigation: Navigation = SceneDelegate.mainNavigation
    
    @StateObject private var viewModel = MainViewModel()
    
    static let homeNavigation = Navigation(root: HomeView(viewModel: HomeViewModel(isShowingAsChild: false)).asDestination())
    
    var body: some View {
            ZStack {
                
                
                NavigationHostView(navigation: MainView.homeNavigation)
                .opacity(viewModel.selectedTab == .home ? 1 : 0)
                .ignoresSafeArea()
                
                
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
            
            // no location
            .overlay(viewModel.shouldDisplayLocationModal != .hidden ? Color("subtitle.gray").opacity(0.3).ignoresSafeArea() : Color.clear.ignoresSafeArea())
            .disabled(viewModel.shouldDisplayLocationModal != .hidden)
            .bottomSheet(
                bottomSheetPosition: $viewModel.shouldDisplayLocationModal,
                switchablePositions: [.relativeTop(0.6)]) {
                    NoServiceModal(
                        title: "No location found!",
                        lottieName: "NoLocation",
                        text: "Please enable location in order to use the app."
                    )
                }
                .customBackground {
                    Color("background.first")
                }
        
            // no network
            .overlay(viewModel.isConnectedToNetwork != .hidden ? Color("subtitle.gray").opacity(0.3).ignoresSafeArea() : Color.clear.ignoresSafeArea())
            .disabled(viewModel.isConnectedToNetwork != .hidden)
            .bottomSheet(
                bottomSheetPosition: $viewModel.isConnectedToNetwork,
                switchablePositions: [.relativeTop(0.6)]) {
                    
                    NoServiceModal(
                        title: "No connection found!",
                        lottieName: "NoInternet",
                        text: "Please turn on mobile data / Wi-Fi in order to use the app!"
                    )
                }
            .customBackground {
                Color("background.first")
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
