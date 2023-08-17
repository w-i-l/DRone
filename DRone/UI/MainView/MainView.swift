//
//  MainView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 07.08.2023.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        NavigationView {
            ZStack{
                
                HomeView(
                    viewModel: HomeViewModel(),
                    isShowingAsChild: false
                )
                .opacity(viewModel.selectedTab == .home ? 1 : 0)
                
                AllFlightRequestView(viewModel: RequestViewModel())
                    .opacity(viewModel.selectedTab == .request ? 1 : 0)
                
                    
                
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
