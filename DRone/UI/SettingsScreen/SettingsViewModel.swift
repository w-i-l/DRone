//
//  SettingsViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 30.08.2023.
//

import Foundation
import Combine
import SwiftUI
import FirebaseAuth

class SettingsViewModel: BaseViewModel {
    
    @Published var user: User = User(
        uid: "",
        email: "",
        firstName: "",
        lastName: "",
        CNP: ""
    )
    
    @Published var loggedIn: Bool = false
    
    override init() {
        
        super.init()
        
        AppService.shared.loginState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if value == .loggedIn {
                    self?.loggedIn = true
                } else {
                    self?.loggedIn = false
                }
            }
            .store(in: &bag)
        
        AppService.shared.user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if let value = value {
                    self?.user = value
                    self?.loggedIn = true
                } else {
                    self?.user = User(
                        uid: "",
                        email: "",
                        firstName: "",
                        lastName: "",
                        CNP: ""
                    )
                    self?.loggedIn = false
                }
            }
            .store(in: &bag)
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            
        } catch {
            
        }
        UserDefaults.standard.removeObject(forKey: "userUID")
        AppService.shared.loginState.value = .notLoggedIn
    }
}
