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
                    
                
                VStack {
                    Spacer()
                    TabBar()
                }
                .ignoresSafeArea()
            }
//            .toolbar(.hidden)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
