//
//  MainViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 07.08.2023.
//

import SwiftUI

class MainViewModel: BaseViewModel {
    @Published var selectedTab: AppNavigationTabs = .home
    
    override init() {
        
        super.init()
        
        AppService.shared.selectedTab
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.selectedTab = value
            }
            .store(in: &bag)
    }
}
