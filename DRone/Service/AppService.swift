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
import CoreLocation
import NotificationCenter
import BackgroundTasks

enum AppNavigationTabs: CaseIterable {
    case home
    case request
    case map
    case settings
}

struct User {
    let uid: String
    let email: String
    let firstName: String
    let lastName: String
    let CNP: String
}

class AppService : BaseViewModel {
    
    static let shared = AppService()
    
    var selectedTab: CurrentValueSubject<AppNavigationTabs, Never> = .init(.home)
    var isTabBarVisible: CurrentValueSubject<Bool, Never> = .init(true)
    var locationStatus: CurrentValueSubject<CLAuthorizationStatus, Never> = .init(.notDetermined)
    
    var focusedTextFieldID: CurrentValueSubject<Int, Never> = .init(0)
    var screenIndex: CurrentValueSubject<Int, Never> = .init(0)
    
    var loginState: CurrentValueSubject<LoginState, Never> = .init(.notLoggedIn)
    
    var user: CurrentValueSubject< User?, Never> = .init(nil)
    
    override private init() {
        super.init()

        if let stateFromDefaults = UserDefaults.standard.object(forKey: "userUID") as? String {
            loginState.value = .loggedIn
            
            self.syncUser()
        }
//        UserDefaults.standard.removeObject(forKey: "loginState")
//        UserDefaults.standard.removeObject(forKey: "email")
    }
    
    func syncUser() {
        FirebaseService.shared.getUserWithInfo()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.user.value = value
            }
            .store(in: &bag)
    }
}
