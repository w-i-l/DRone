//
//  OnBoardView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 04.09.2023.
//

import SwiftUI

struct OnBoardView: View {

    @StateObject private var viewModel: OnBoardViewModel = .init()
    private var navigation = SceneDelegate.mainNavigation
    
    @State private var zIndex: Double = 0
    
//    init() {
//
//    }

    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            
            VStack {

                
                let views = [
                    OnBoardMockUpView(
                        image: "home.mock.up",
                        text: "Check the right time to fly",
                        viewModel: self.viewModel
                    ),
                    OnBoardMockUpView(
                        image: "request.mock.up",
                        text: "Request permission to fly",
                        viewModel: self.viewModel
                    ),
                    OnBoardMockUpView(
                        image: "map.mock.up",
                        text: "View No-Fly zones",
                        viewModel: self.viewModel
                    )
                ]
                
                
                HStack {
                    ForEach(0..<3) { no in
                        views[no]
                            .frame(width: UIScreen.main.bounds.width)
                    }
                }
                .offset(x: UIScreen.main.bounds.width)
                .offset(x: -UIScreen.main.bounds.width * CGFloat(viewModel.screenIndex))
                .gesture(
                    DragGesture()
                        .onEnded({ drag in
                            withAnimation(.default) {
                                if drag.translation.width > 0 {
                                    viewModel.screenIndex -= 1
                                    viewModel.screenIndex = max(viewModel.screenIndex, 0)
                                } else {
                                    viewModel.screenIndex += 1
                                    viewModel.screenIndex =  min(viewModel.screenIndex, 2)
                                }
                            }
                        })
                )
                
                HStack {
                    ForEach(0..<3) { no in
                        Button( action: {
                            withAnimation(.default) {
                                viewModel.screenIndex = no
                            }
                        }, label: {
                            Circle()
                                .fill(no == viewModel.screenIndex ? Color("accent.blue") : .white)
                            .frame(width: 16)
                        })
                    }
                }
                
                Button {
                    if viewModel.screenIndex != 2 {
                        withAnimation(.default) {
                            viewModel.screenIndex = min(viewModel.screenIndex + 1, 2)
                        }
                    } else {
                        navigation.replaceNavigationStack([LoginView().asDestination(tag: "LoginView")], animated: true)
                    }

                } label: {
                    ZStack {
                        Color("accent.blue")
                            .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                            .cornerRadius(12)
                        
                        Text(viewModel.screenIndex == 2 ? "Finish" : "Next")
                            .foregroundColor(.white)
                            .font(.asket(size: 20))
                    }
                }
                .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            )
            .zIndex(zIndex)
            
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        zIndex = 4
                    }
                }
                
        }
    }
}

struct OnBoardView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardView()
    }
}
