//
//  TextField.swift
//  DRone
//
//  Created by Mihai Ocnaru on 10.08.2023.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    
    @State private var isFocused = false
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(isFocused ? Color.blue : Color.gray, lineWidth: 1)
            )
            .onTapGesture {
                isFocused = true
            }
    }
}


// dismiss keyboard
extension View {
    func dismissKeyboard() {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true)
        
        // synchronise with text fields
        AppService.shared.focusedTextFieldID.value = -1
      }
}
