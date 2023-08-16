//
//  CustomTextField.swift
//  DRone
//
//  Created by Mihai Ocnaru on 11.08.2023.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var text: String
    let placeholderText: String
    let isTextGood: () -> Bool
    
    @StateObject var viewModel = CustomTextFieldViewModel()
    
    
    private static var focusedTextFieldID: Int = 0
    private static var textFieldIndex: Int = 0
    private let textFieldID: Int
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(viewModel.textFieldID == viewModel.focusedTextFieldID ? Color("accent.blue") : .white, lineWidth: 3)
                )
            
            TextField("", text: $text)
                .placeholder(when: text.isEmpty) {
                    Text(placeholderText)
                        .foregroundColor(Color("subtitle.gray"))
                        .font(.abel(size: 16))
            }
                .padding(12)
                .foregroundColor(Color("background.first"))
                
        }
        .onTapGesture {
            AppService.shared.focusedTextFieldID.value = viewModel.textFieldID
        }
    }
    
    init(text: Binding<String>, placeholderText: String, isTextGood: @escaping () -> Bool) {
        self._text = text
        self.placeholderText = placeholderText
        self.isTextGood = isTextGood
        self.textFieldID = CustomTextField.textFieldIndex + 1
        CustomTextField.textFieldIndex += 1
    }
}

struct CustomTextField_Previews: PreviewProvider {
    @State private var text = ""
    
    static var previews: some View {
        VStack {
            CustomTextField(text: .constant(""), placeholderText: "Last name...") {
                .random()
            }
            
            CustomTextField(text: .constant(""), placeholderText: "Last name...") {
                .random()
            }
        }
            .frame(maxHeight: .infinity)
            .background(Color.black, alignment: .leading)
    }
}
