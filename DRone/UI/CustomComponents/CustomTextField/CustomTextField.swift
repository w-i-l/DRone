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
    @State private var textFieldDidReturn: Bool = false
    @State private var strokeColor: Color = .white
    
    private static var focusedTextFieldID: Int = 0
    private static var textFieldIndex: Int = 0
    private let textFieldID: Int
    
    @State private var isFocused = false
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(strokeColor, lineWidth: 3)
                )
                .onTapGesture {
                    isFocused = true
                }
            
            TextField("", text: $text, onEditingChanged: { _ in
                
            }, onCommit: {
                textFieldDidReturn = true
            })
                .placeholder(when: text.isEmpty) {
                    Text(placeholderText)
                        .foregroundColor(Color("subtitle.gray"))
                        .font(.abel(size: 16))
            }
                .padding(12)
                .foregroundColor(Color("background.first"))
                .frame(height: 40)
                
        }
        .onChange(of: textFieldDidReturn, perform: { newValue in
            if !newValue && viewModel.textFieldID == viewModel.focusedTextFieldID {
                strokeColor = Color("accent.blue")
            } else {
                strokeColor = .white
            }
        })
        .onChange(of: viewModel.focusedTextFieldID, perform: { newValue in
            if newValue == viewModel.textFieldID && !textFieldDidReturn{
                strokeColor = Color("accent.blue")
            } else {
                strokeColor = .white
            }
        })
        .onTapGesture {
            AppService.shared.focusedTextFieldID.value = viewModel.textFieldID
            self.textFieldDidReturn = false
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