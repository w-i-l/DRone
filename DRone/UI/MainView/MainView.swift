//
//  MainView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 07.08.2023.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var navigation: Navigation
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
            ZStack{
                
                HomeView(
                    viewModel: HomeViewModel(),
                    isShowingAsChild: false
                )
                .opacity(viewModel.selectedTab == .home ? 1 : 0)
                .environmentObject(navigation)
                
                
                AllFlightRequestView(viewModel: RequestViewModel())
                    .opacity(viewModel.selectedTab == .request ? 1 : 0)
                
                GoogleMapsView(viewModel: GoogleMapsViewModel())
                    .opacity(viewModel.selectedTab == .map ? 1 : 0)
                
                VStack {
                    Spacer()
                    TabBar()
                }
                .ignoresSafeArea()
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
