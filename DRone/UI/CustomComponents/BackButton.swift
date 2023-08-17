//
//  BackButton.swift
//  DRone
//
//  Created by Mihai Ocnaru on 17.08.2023.
//

import SwiftUI

struct BackButton: View {
    
    @Environment(\.dismiss) private var dismiss
    let text: String
    var action: (() -> Void)?
    var body: some View {
        HStack {
            Button(action: {
                if action == nil {
                    dismiss()
                } else {
                    action!()
                }
            }) {
                HStack(spacing: 14) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 14, height: 14)
                        .scaledToFit()
                        .foregroundColor(.white)
                    
                    Text(text)
                        .font(.abel(size: 24))
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
        }
        .padding(.leading, 10)
    }
    
    init(text: String, action: (() -> Void)? = nil) {
        self.text = text
        self.action = action
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton(text: "Back")
    }
}
