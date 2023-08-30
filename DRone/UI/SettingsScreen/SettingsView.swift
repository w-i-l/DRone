//
//  SettingView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 30.08.2023.
//

import SwiftUI

struct SettingView: View {
    
    @StateObject var viewModel: SettingsViewModel
    @EnvironmentObject private var navigation: Navigation
    
    var body: some View {
        VStack {
            if viewModel.loggedIn {
                
                GeometryReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack {
                            Text("Hello, \(viewModel.user.firstName) \(viewModel.user.lastName)!")
                                .foregroundColor(.white)
                                .font(.asket(size: 32))
                            
                            Spacer()
                            
                            Button {
                                viewModel.logOut()
                            } label: {
                                ZStack {
                                    Color("red")
                                        .cornerRadius(12)
                                        .frame(width: 150, height: 60)
                                    
                                    Text("Sign out")
                                        .foregroundColor(.white)
                                        .font(.asket(size: 20))
                                }
                            }
                            
                        }
                        .frame(minHeight: proxy.size.height - UIScreen.main.bounds.height / 11.3)
                        .frame(width: proxy.size.width)
                        .padding(.bottom, UIScreen.main.bounds.height / 11.3)
                    }
                }
            } else {
                VStack {
                    Text("You are not logged in!")
                        .foregroundColor(.white)
                        .font(.asket(size: 20))
                    
                    Spacer()
                    
                    Button {
                        navigation.replaceNavigationStack([LoginView(viewModel: LoginViewModel()).asDestination()], animated: true)
                    } label: {
                        ZStack {
                            Color("accent.blue")
                                .cornerRadius(12)
                                .frame(width: 150, height: 60)
                            
                            Text("Login")
                                .foregroundColor(.white)
                                .font(.asket(size: 20))
                        }
                    }
                }
                .padding(.bottom, UIScreen.main.bounds.height / 11.3)
            }
                
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(viewModel: SettingsViewModel())
    }
}
