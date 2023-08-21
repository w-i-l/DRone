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
    @Published var nextButtonPressed: Bool = false
    
    static var textFieldCount: Int = 0
    let textFieldID: Int
    
    init(nextButtonPressed: CurrentValueSubject<Bool, Never>) {
        
        textFieldID = CustomTextFieldViewModel.textFieldCount + 1
    
        super.init()
        
        CustomTextFieldViewModel.textFieldCount += 1
        
        AppService.shared.focusedTextFieldID
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.focusedTextFieldID = value
            }
            .store(in: &bag)
        
        nextButtonPressed
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.nextButtonPressed = value
            }
            .store(in: &bag)
    }
}
