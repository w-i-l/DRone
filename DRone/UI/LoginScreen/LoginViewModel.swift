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
    
    @Published var firstName: String = ""
    @Published var firstNameError: String = ""
    
    @Published var lastName: String = ""
    @Published var lastNameError: String = ""
    
    @Published var CNP: String = ""
    @Published var CNPError: String = ""
    
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
    
    func firstNameValidation() -> Bool {
        
        if !containsOnlyLetters(firstName) {
            firstNameError = "First name should contain only letters!"
            return false
        } else if firstName.contains(where: { $0 == " " }) {
            firstNameError = "Enter only a first name!"
            return false
        }
        
        return onlyStringValidation(string: firstName)
    }
    
    func lastNameValidation() -> Bool {
        
        if !containsOnlyLetters(lastName) {
            lastNameError = "Last name should contain only letters!"
            return false
        } else if firstName.contains(where: { $0 == " " }) {
            lastNameError = "Enter only a last name!"
            return false
        }
        
        return onlyStringValidation(string: lastName)
    }
    
    func cnpValidation() -> Bool {
        if !containsOnlyNumbers(CNP) {
            CNPError = "CNP should contain only numbers!"
            return false
        } else if CNP.count != 13 {
            CNPError = "CNP should have 13 characters!"
            return false
        } else if getBirthDayFromCNP() == nil {
            CNPError = "Your birthday isn't valid!"
            return false
        } else if !["1", "2", "5", "6"].contains(CNP[CNP.startIndex]) {
            CNPError = "Your first digit must represent your sex!"
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
    
    
    func getBirthDayFromCNP() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let yearStartIndex = CNP.index(CNP.startIndex, offsetBy: 1)
        let yearEndIndex = CNP.index(CNP.startIndex, offsetBy: 2)
        let last2DigitsOfBirthdayYear = String(CNP[yearStartIndex...yearEndIndex])
        let birthdayYear = "\(Int(last2DigitsOfBirthdayYear)! > 23 ? "19" : "20")\(last2DigitsOfBirthdayYear)"
        
        let monthStartIndex = CNP.index(CNP.startIndex, offsetBy: 3)
        let monthEndIndex = CNP.index(CNP.startIndex, offsetBy: 4)
        let birthdayMonth = String(CNP[monthStartIndex...monthEndIndex])
        
        let dayStartIndex = CNP.index(CNP.startIndex, offsetBy: 5)
        let dayEndIndex = CNP.index(CNP.startIndex, offsetBy: 6)
        let birthdayDay = String(CNP[dayStartIndex...dayEndIndex])
        
        let birthdayDateFromCNP = "\(birthdayDay)/\(birthdayMonth)/\(birthdayYear)"
        return dateFormatter.date(from: birthdayDateFromCNP)
        
    }
    
    func clear() {
        
        email = ""
        emailError = ""
        password = ""
        passwordError = ""
        
        showWrongPasswordToast = false
        showTooManyRequestsToast = false
        showEmailNotVerifiedToast = false
        showLoginSuccesfulToast = false
        showLoadingToast = false
        
    }
    
    func goToAuth() {
        clear()
        navigation.push(AuthView(viewModel: self).asDestination(), animated: true)
    }
    
}
