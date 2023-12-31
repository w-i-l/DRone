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
                                        .frame(height: 60)
                                    
                                    HStack {
                                        Text("Logout")
                                            .foregroundColor(.white)
                                            .font(.asket(size: 24))
                                        
        //                                        Image(systemName: "chevron.right")
        //                                            .resizable()
        //                                            .renderingMode(.template)
        //                                            .foregroundColor(.white)
        //                                            .frame(width: 10, height: 10)
        //                                            .scaledToFit()
                                    }
                                    .padding(.vertical, 10)
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
                    
                    Button (action: {
                        
//                        navigation.replaceNavigationStack([LoginView(isPresentedAsFirstScreen: false).asDestination()], animated: true)
                        navigation.push(LoginView(isPresentedAsFirstScreen: false).asDestination(tag: "LoginView"), animated: true)
                        
                    }, label: {
                        ZStack {
                            Color("accent.blue")
                                .cornerRadius(12)
                                .frame(height: 60)
                            
                            HStack {
                                Text("Login")
                                    .foregroundColor(.white)
                                    .font(.asket(size: 24))
                                
//                                        Image(systemName: "chevron.right")
//                                            .resizable()
//                                            .renderingMode(.template)
//                                            .foregroundColor(.white)
//                                            .frame(width: 10, height: 10)
//                                            .scaledToFit()
                            }
                            .padding(.vertical, 10)
                        }
                    })
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
