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
    @ObservedObject private var navigation: Navigation
    
    init(viewModel: LoginViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self.navigation = SceneDelegate.navigation
    }
    
    var body: some View {
        
        VStack {
            
            BackButton(text: "Auth")
            
            ScrollView(showsIndicators: false) {
                VStack {
                    
                    LottieView(name: "FlyingDrone")
                        .lottieLoopMode(.autoReverse)
                        .frame(width: UIScreen.main.bounds.width, height: 300)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Sign up")
                            .foregroundColor(.white)
                            .font(.asket(size: 36))
                        
                        Text("Enter you email and password")
                            .foregroundColor(.white)
                            .font(.asket(size: 20))
                    }
                    .padding(.top, 20)
                    
                    // email and password
                    VStack(spacing: 4) {
                        
                        HStack(spacing: 10) {
                            Image(systemName: "person")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .scaledToFit()
                            
                            Color("accent.blue")
                                .frame(width: 1, height: 40)
                            
                            CustomTextField(
                                text: $viewModel.firstName,
                                placeholderText: "first name",
                                isTextGood: viewModel.firstNameValidation,
                                errorText: $viewModel.firstNameError,
                                viewModel: CustomTextFieldViewModel(nextButtonPressed: viewModel.loginButtonPressed),
                                keyboardType: .emailAddress
                            )
                            .frame(width: UIScreen.main.bounds.width / 1.5)
                            .padding(.trailing, 10)
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color("accent.blue"))
                                    .frame(width: 20, height: 15)
                                    .scaledToFit()
                                
                            }
                        }
                        
                        Color("accent.blue")
                            .frame(height: 1)
                            .padding(.horizontal, 35)
                            .padding(.vertical, 10)
                        
                        HStack(spacing: 10) {
                            Image(systemName: "person")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .scaledToFit()
                            
                            Color("accent.blue")
                                .frame(width: 1, height: 40)
                            
                            CustomTextField(
                                text: $viewModel.lastName,
                                placeholderText: "last name",
                                isTextGood: viewModel.lastNameValidation,
                                errorText: $viewModel.lastNameError,
                                viewModel: CustomTextFieldViewModel(nextButtonPressed: viewModel.loginButtonPressed)
                            )
                            .frame(width: UIScreen.main.bounds.width / 1.5)
                            .padding(.trailing, 10)
                            
                            Button {
                                viewModel.isTextFieldSecures.toggle()
                            } label: {
                                Image("")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color("accent.blue"))
                                    .frame(width: 20, height: 15)
                                    .scaledToFit()
                            }
                            
                        }
                        
                        Color("accent.blue")
                            .frame(height: 1)
                            .padding(.horizontal, 35)
                            .padding(.vertical, 10)
                        
                        
                        HStack(spacing: 10) {
                            Image(systemName: "creditcard.and.123")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 15)
                                .scaledToFit()
                            
                            Color("accent.blue")
                                .frame(width: 1, height: 40)
                            
                            CustomTextField(
                                text: $viewModel.CNP,
                                placeholderText: "CNP",
                                isTextGood: viewModel.cnpValidation,
                                errorText: $viewModel.CNPError,
                                viewModel: CustomTextFieldViewModel(nextButtonPressed: viewModel.loginButtonPressed),
                                keyboardType: .numberPad
                            )
                            .frame(width: UIScreen.main.bounds.width / 1.5)
                            .padding(.trailing, 10)
                            
                            Button {
                                viewModel.isTextFieldSecures.toggle()
                            } label: {
                                Image("")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color("accent.blue"))
                                    .frame(width: 20, height: 15)
                                    .scaledToFit()
                            }
                            
                        }
                        .padding(.top, 30)
                        
                        Color("accent.blue")
                            .frame(height: 1)
                            .padding(.horizontal, 35)
                            .padding(.vertical, 10)
                    }
                    .padding(.top, 40)
                    
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
                
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
        .onTapGesture {
            dismissKeyboard()
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
