//
//  SubmitedResponseView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 16.08.2023.
//

import SwiftUI

struct ResponseView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var navigation: Navigation
    
    let image: String
    let title: String
    let subtitle: String
    let captation: String
    let showButton: Bool
    let buttonText: String
    let buttonAction: () -> Void
    
    init(image: String, title: String, subtitle: String, captation: String, showButton: Bool = false, buttonText: String = "Request another flight", buttonAction: @escaping () -> Void = {}) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.captation = captation
        self.showButton = showButton
        self.buttonText = buttonText
        self.buttonAction = buttonAction
        
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                Image(image)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8)
                
                Text(title)
                    .foregroundColor(.white)
                    .font(.abel(size: 40))
                    .padding(.top, 33)
                
                Text(subtitle)
                    .foregroundColor(.white)
                    .font(.abel(size: 24))
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
                
                Spacer()
                
                Text(captation)
                    .font(.abel(size: 16))
                    .foregroundColor(.white)
                    .padding(.top, UIScreen.main.bounds.height / 10)
                
                if showButton {
                    Button {
                        self.navigation.navigationController.interactivePopGestureRecognizer?.isEnabled = true
                        navigation.popToRoot(animated: false)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color("accent.blue"))
                                .frame(width: UIScreen.main.bounds.width / 2, height: 50)
                            
                            Text(buttonText)
                                .font(.abel(size: 20))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 4)
                }
                
            }
            .frame(minHeight: proxy.size.height)
            .frame(minWidth: proxy.size.width)
        }
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

extension ResponseView: Identifiable {
    var id: String {
        image + title + subtitle + captation
    }
}

extension ResponseView: Hashable {
    static func == (lhs: ResponseView, rhs: ResponseView) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
}

struct SubmitedResponseView_Previews: PreviewProvider {
    static var previews: some View {
        ResponseView(
            image: "waiting.image",
            title: "Done!",
            subtitle: "Your submission is under review \n Submission ID: 312345",
            captation: "You will receive a confirmation in a short time."
        )
    }
}
