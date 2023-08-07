//
//  AppService.swift
//  DRone
//
//  Created by Mihai Ocnaru on 07.08.2023.
//

// All data that should be visible inthe whole app
// like dark/light mode, current tab selected etc.

import SwiftUI
import Combine

enum AppNavigationTabs: CaseIterable {
    case home
    case request
    case map
}

class AppService {
    
    static let shared = AppService()
    
    var selectedTab: CurrentValueSubject<AppNavigationTabs, Never> = .init(.home)
    var isTabBarVisible: CurrentValueSubject<Bool, Never> = .init(true)
    
    private init() {}
}
