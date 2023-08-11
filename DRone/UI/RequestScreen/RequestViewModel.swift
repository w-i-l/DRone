//
//  RequestViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 10.08.2023.
//

import SwiftUI

class RequestViewModel: BaseViewModel {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var CNP: String = ""
    
    @Published var birthdayDate: Date = .init()
    
    @Published var screenIndex = 0
    
    override init() {
        super.init()
        
        AppService.shared.screenIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.screenIndex = value
            }
            .store(in: &bag)
    }
}
