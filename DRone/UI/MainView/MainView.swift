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
        NavigationStack{
            ZStack{
                
                HomeView(viewModel: HomeViewModel())
                    
                
                VStack {
                    Spacer()
                    TabBar()
                }
                .ignoresSafeArea()
            }
            .toolbar(.hidden)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
