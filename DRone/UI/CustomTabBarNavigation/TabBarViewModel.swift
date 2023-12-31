//
//  TabBarViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 07.08.2023.
//

import SwiftUI

class TabBarViewModel: BaseViewModel {
    
    @Published var selectedTab: AppNavigationTabs = .home
    @Published var isTabBarVisible: Bool = true
    
    @Published var guestMode: Bool = true
    
    override init() {
        
        super.init()
        
        AppService.shared.selectedTab
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.selectedTab = value
            }
            .store(in: &bag)
        
        AppService.shared.isTabBarVisible
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.isTabBarVisible = value
            }
            .store(in: &bag)
        
        AppService.shared.loginState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if value == .loggedIn {
                    self?.guestMode = false
                } else {
                    self?.guestMode = true
                }
            }
            .store(in: &bag)
    }
}
