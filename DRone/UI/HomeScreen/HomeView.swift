//
//  HomeView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 07.08.2023.
//

import SwiftUI
import AlertToast
import Lottie
import LottieSwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var navigation: Navigation
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            switch viewModel.fetchingState {
            case .loading :
                
                HomeViewLoading(isShowingAsChild: viewModel.isShowingAsChild)
                Spacer()
                
            case .loaded:
                HomeViewLoaded(
                    viewModel: viewModel
                )
                .environmentObject(navigation)
                
            case .failure :
                HomeViewFailed(viewModel: viewModel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            viewModel: HomeViewModel(isShowingAsChild: false)
        )
    }
}
