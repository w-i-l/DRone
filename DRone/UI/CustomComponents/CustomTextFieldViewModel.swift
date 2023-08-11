//
//  CustomTextFieldViewModel.swift
//  DRone
//
//  Created by Mihai Ocnaru on 11.08.2023.
//

import SwiftUI
import Combine

class CustomTextFieldViewModel: BaseViewModel {
    @Published var focusedTextFieldID: Int = 0
    
    static var textFieldCount: Int = 0
    let textFieldID: Int
    
    override init() {
        textFieldID = CustomTextFieldViewModel.textFieldCount + 1
    
        super.init()
        
        CustomTextFieldViewModel.textFieldCount += 1
        
        AppService.shared.focusedTextFieldID
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.focusedTextFieldID = value
            }
            .store(in: &bag)
    }
}
