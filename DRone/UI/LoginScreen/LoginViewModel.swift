//
//  LoginViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 29.08.2023.
//

import SwiftUI
import Combine

class LoginViewModel: BaseViewModel {
    
    @ObservedObject private var navigation: Navigation
    
    @Published var email: String = ""
    @Published var emailError: String = ""
    
    @Published var password: String = ""
    @Published var passwordError: String = ""
    @Published var isTextFieldSecures: Bool = true
    
    @Published var showWrongPasswordToast: Bool = false
    @Published var showTooManyRequestsToast: Bool = false
    @Published var showEmailNotVerifiedToast: Bool = false
    @Published var showLoginSuccesfulToast: Bool = false
    @Published var showLoadingToast: Bool = false
    
    @Published var loginStatus: FetchingState = .loaded
    
    var loginButtonPressed: CurrentValueSubject<Bool, Never> = .init(false)
    
    @Published var rememberMe: Bool = false
    
    override init() {
        self._navigation = ObservedObject(wrappedValue: SceneDelegate.navigation)
        
        super.init()
        
        if AppService.shared.loginState.value == .loggedIn {
            self.navigation.replaceNavigationStack([MainView().asDestination()], animated: true)
        }
    }
    
    func passwordValidation() -> Bool {
        if password.count < 10 {
            passwordError = "Password should have at least 10 characters!"
            return false
        } else if !containsLetters(password) {
            passwordError = "Password should contains numbers too!"
            return false
        } else if !containsNumbers(password) {
            passwordError = "Password should contains letters too!"
            return false
        } else if containsOnlyLetters(password) && containsNumbers(password){
            passwordError = "Password should contain at least one special character!"
            return false
        } else if containsOnlyAlphanumericsAndSpecialChars(password) == false {
            passwordError = "Password should contain only alphanumeric and special characters!"
            return false
        }
        
        return true
    }
    
    func emailValidation() -> Bool {
        if isValidEmail(email) == false {
            emailError = "Please enter a valid email adress"
            return false
        }
        
        return true
    }
    
    func login() {
        
        if emailValidation() && passwordValidation() {
            self.loginButtonPressed.value = false
        } else {
            return
            
        }
        
        self.loginStatus = .loading
        self.showLoadingToast = true
        
        FirebaseService.shared.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                switch value {
                case .tooManyRequests:
                    self?.showTooManyRequestsToast = true
                case .wrongPassword :
                    self?.showWrongPasswordToast = true
                    
                case .emailNotVerified:
                    self?.showEmailNotVerifiedToast = true
                    
                case .loggedIn:
                    self?.showLoginSuccesfulToast = true
                    AppService.shared.loginState.value = .loggedIn
                    self?.navigation.replaceNavigationStack([MainView().asDestination()], animated: true)
                    
                    if self!.rememberMe {
                        UserDefaults.standard.set(self?.email, forKey: "email")
                        UserDefaults.standard.set(AppService.shared.loginState.value.rawValue, forKey: "loginState")
                    } else {
                        UserDefaults.standard.removeObject(forKey: "email")
                        UserDefaults.standard.removeObject(forKey: "loginState")
                    }
                case .error:
                    self?.loginStatus = .failure
                    return
                default :
                    break
                }
                
                self?.loginStatus = .loaded
                self?.showLoadingToast = false
                print(value)
            })
            .store(in: &bag)
    }
}
