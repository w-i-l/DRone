//
//  MainViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 07.08.2023.
//

import SwiftUI
import BottomSheet

class MainViewModel: BaseViewModel {
    @Published var selectedTab: AppNavigationTabs = .home
    @Published var shouldDisplayLocationModal: BottomSheetPosition = .hidden
    
    @Published var isConnectedToNetwork : BottomSheetPosition = .hidden
    
    override init() {
        
        super.init()
        
        AppService.shared.selectedTab
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.selectedTab = value
            }
            .store(in: &bag)
        
        AppService.shared.locationStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if value == .authorizedAlways || value == .authorizedWhenInUse {
                    self?.shouldDisplayLocationModal = .hidden
                    AppService.shared.isTabBarVisible.value = true
                } else {
                    self?.shouldDisplayLocationModal = .relativeTop(0.6)
                    AppService.shared.isTabBarVisible.value = false
                }
            }
            .store(in: &bag)
        
        NetworkService.shared.isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if value {
                    self?.isConnectedToNetwork = .hidden
                    AppService.shared.isTabBarVisible.value = true
                } else {
                    self?.isConnectedToNetwork = .relativeTop(0.6)
                    AppService.shared.isTabBarVisible.value = false
                }
            }
            .store(in: &bag)
    }
}
