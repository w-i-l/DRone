//
//  AuthAdditionalView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 29.08.2023.
//

import SwiftUI
import LottieSwiftUI
import AlertToast

struct AuthAdditionalView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    private let navigation = SceneDelegate.mainNavigation
    
    var body: some View {
        VStack {
            
            BackButton(text: "Auth")
            
            
            GeometryReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack {
                        
                        LottieView(name: "FlyingDrone")
                            .lottieLoopMode(.autoReverse)
                            .frame(width: UIScreen.main.bounds.width, height: 200)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Complete your profile")
                                .foregroundColor(.white)
                                .font(.asket(size: 36))
                            
                            Text("Enter your personal info")
                                .foregroundColor(.white)
                                .font(.asket(size: 20))
                        }
                        .padding(.top, 20)
                        
                        // email and password
                        VStack(spacing: 0) {
                            
                            HStack(spacing: 10) {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                
                                Color("accent.blue")
                                    .frame(width: 1, height: 50)
                                
                                CustomTextField(
                                    text: $viewModel.firstName,
                                    placeholderText: "First name",
                                    isTextGood: viewModel.firstNameValidation,
                                    errorText: $viewModel.firstNameError,
                                    viewModel: CustomTextFieldViewModel(nextButtonPressed: viewModel.loginButtonPressed)
                                )
                                .frame(width: UIScreen.main.bounds.width / 1.3)
                                .padding(.trailing, 10)
                            }
                            
                            Color("accent.blue")
                                .frame(height: 1)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 5)
                            
                            HStack(spacing: 10) {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                
                                Color("accent.blue")
                                    .frame(width: 1, height: 50)
                                
                                CustomTextField(
                                    text: $viewModel.lastName,
                                    placeholderText: "Last name",
                                    isTextGood: viewModel.lastNameValidation,
                                    errorText: $viewModel.lastNameError,
                                    viewModel: CustomTextFieldViewModel(nextButtonPressed: viewModel.loginButtonPressed)
                                )
                                .frame(width: UIScreen.main.bounds.width / 1.3)
                                .padding(.trailing, 10)

                                
                            }
                            
                            Color("accent.blue")
                                .frame(height: 1)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 5)
                            
                            
                            HStack(spacing: 10) {
                                Image(systemName: "person.text.rectangle.fill")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 15)
                                    
                                
                                Color("accent.blue")
                                    .frame(width: 1, height: 50)
                                
                                CustomTextField(
                                    text: $viewModel.CNP,
                                    placeholderText: "CNP",
                                    isTextGood: viewModel.cnpValidation,
                                    errorText: $viewModel.CNPError,
                                    viewModel: CustomTextFieldViewModel(nextButtonPressed: viewModel.loginButtonPressed),
                                    keyboardType: .numberPad
                                )
                                .frame(width: UIScreen.main.bounds.width / 1.3)
                                .padding(.trailing, 10)
                                
                            }
                            .padding(.top, 30)
                            
                            Color("accent.blue")
                                .frame(height: 1)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 5)
                        }
                        .padding(.top, 20)
                        
                        // remember me toggle
                        HStack {
                            
                            Toggle(
                                isOn: $viewModel.rememberMe) {
                                }.opacity(0)
                            
                            
                            Text("")
                                .foregroundColor(.white)
                                .font(.asket(size: 16))
                            
                            Spacer()
                        }
                        .frame(width: 70)
                        .frame(maxWidth: .infinity)
                        
                        
                        Spacer()
                        
                        Button {
                            viewModel.loginButtonPressed.value = true
                            dismissKeyboard()
                            
                            if viewModel.firstNameValidation() && viewModel.lastNameValidation() && viewModel.cnpValidation() {
                                viewModel.auth()
                            }
                            
                        } label: {
                            ZStack {
                                Color("accent.blue")
                                    .frame(width: 250, height: 50)
                                    .cornerRadius(12)
                                
                                Text("Authentificate")
                                    .foregroundColor(.white)
                                    .font(.asket(size: 20))
                            }
                        }
                        
                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(.white)
                                .font(.asket(size: 16))
                            
                            Button {
                                viewModel.clear()
                                navigation.pop(animated: true)
                            } label: {
                                Text("Login")
                                    .foregroundColor(Color("accent.blue"))
                                    .font(.asket(size: 20))
                            }
                            
                        }
                        .padding(.top, 10)
                        
                        
                        
                    }
                    .frame(minHeight: proxy.size.height)
                    .frame(width: proxy.size.width)
                }
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
        .onTapGesture {
            dismissKeyboard()
            viewModel.clearToasts()
        }
        .disabled(viewModel.showLoadingToast)
        .toast(
            isPresenting: $viewModel.showLoadingToast,
            tapToDismiss: false,
            alert: {
                AlertToast(
                    displayMode: .alert,
                    type: .loading
                )
            }
        )
    }
}

struct AuthAdditionalView_Previews: PreviewProvider {
    static var previews: some View {
        AuthAdditionalView(viewModel: LoginViewModel())
    }
}
