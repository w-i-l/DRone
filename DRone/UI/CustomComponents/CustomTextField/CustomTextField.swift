//
//  CustomTextField.swift
//  DRone
//
//  Created by Mihai Ocnaru on 11.08.2023.
//

import SwiftUI
import Combine

struct CustomTextField: View {
    
    @Binding var text: String
    let placeholderText: String
    let isTextGood: () -> Bool
    let errorText: String
    
    @StateObject var viewModel: CustomTextFieldViewModel
    @State private var textFieldDidReturn: Bool = false
    @State private var strokeColor: Color = .white
    
    private static var focusedTextFieldID: Int = 0
    private static var textFieldIndex: Int = 0
    private let textFieldID: Int
    
    @State private var isFocused = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            if viewModel.nextButtonPressed && !isTextGood() {
                Text(errorText)
                    .font(.abel(size: 16))
                    .foregroundColor(Color("red"))
            }
            
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
        .onChange(of: viewModel.nextButtonPressed) { newValue in
//            guard newValue == true else { return }
            self.strokeColor = isTextGood() ? .white : Color("red")
            viewModel.nextButtonPressed = false
        }
        .onChange(of: AppService.shared.screenIndex.value) { _ in
            self.strokeColor = .white
        }
    }
    
    init(
        text: Binding<String>,
        placeholderText: String,
        isTextGood: @escaping () -> Bool,
        errorText: String,
        viewModel: CustomTextFieldViewModel
    ) {
        self._text = text
        self.placeholderText = placeholderText
        self.isTextGood = isTextGood
        self.textFieldID = CustomTextField.textFieldIndex + 1
        self.errorText = errorText
        CustomTextField.textFieldIndex += 1
        
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
}

struct CustomTextField_Previews: PreviewProvider {
    @State private var text = ""
    
    static var previews: some View {
        VStack {
            CustomTextField(
                text: .constant("2312"),
                placeholderText: "LastName",
                isTextGood: {
                    .random()
                },
                errorText: "some error",
                viewModel: CustomTextFieldViewModel(nextButtonPressed: CurrentValueSubject<Bool, Never>.init(false))
            )
        }
            .frame(maxHeight: .infinity)
            .background(Color.black, alignment: .leading)
    }
}
