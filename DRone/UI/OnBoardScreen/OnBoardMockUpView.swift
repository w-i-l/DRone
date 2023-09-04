//
//  HomeSplashView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 04.09.2023.
//

import SwiftUI

struct OnBoardMockUpView: View {
    
    let image: String
    let text: String
    
    @ObservedObject var viewModel: OnBoardViewModel
    
    var body: some View {
        VStack {
            
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: UIScreen.main.bounds.height * 0.6)
            
            
            Text(text)
                .font(.asket(size: 24))
                .foregroundColor(.white)
                .padding(.top, 20)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
    }
}

struct OnBoardMockUpView_PReviwe: PreviewProvider {
    static var previews: some View {
        OnBoardMockUpView(
            image: "home.mock.up",
            text: "Check the right time to fly",
            viewModel: OnBoardViewModel()
        )
    }
}


extension OnBoardMockUpView: Identifiable {
    var id: String {
        return self.text
    }
}

extension OnBoardMockUpView: Hashable {
    static func == (lhs: OnBoardMockUpView, rhs: OnBoardMockUpView) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }
}
