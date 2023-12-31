//
//  DRoneApp.swift
//  DRone
//
//  Created by Mihai Ocnaru on 07.08.2023.
//

import SwiftUI
import netfox
import CoreLocation


struct RootView: View {
    
    private let mainNavigation = SceneDelegate.mainNavigation
    
    var body: some View {
        NavigationHostView(navigation: mainNavigation)
            .ignoresSafeArea()
    }
}
