//
//  AuthView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 29.08.2023.
//

import SwiftUI
import LottieSwiftUI
import AlertToast

struct AuthView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    private let navigation = SceneDelegate.mainNavigation
    
    var body: some View {
        VStack {
            
            BackButton(text: "Login")
            
            GeometryReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack {
                        
                        LottieView(name: "FlyingDrone")
                            .lottieLoopMode(.autoReverse)
                            .frame(width: UIScreen.main.bounds.width, height: 200)
                        
                        Spacer()
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Sign up")
                                    .foregroundColor(.white)
                                    .font(.asket(size: 36))
                                
                                Text("Create a new account")
                                    .foregroundColor(.white)
                                    .font(.asket(size: 20))
                            }
                            Spacer()
                        }
                        .padding(20)
                        
                        // email and password
                        VStack(spacing: 0) {
                            
                            HStack(spacing: 10) {
                                Image(systemName: "envelope.fill")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 15)
                                
                                Color("accent.blue")
                                    .frame(width: 1, height: 50)
                                
                                CustomTextField(
                                    text: $viewModel.email,
                                    placeholderText: "email",
                                    isTextGood: viewModel.emailValidation,
                                    errorText: $viewModel.emailError,
                                    viewModel: CustomTextFieldViewModel(nextButtonPressed: viewModel.loginButtonPressed),
                                    keyboardType: .emailAddress
                                )
                                .frame(width: UIScreen.main.bounds.width / 1.3)
                                .padding(.trailing, 10)

                            }
                            
                            Color("accent.blue")
                                .frame(height: 1)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 5)
                            
                            HStack(spacing: 10) {
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 18)
                                
                                Color("accent.blue")
                                    .frame(width: 1, height: 50)
                                
                                CustomTextField(
                                    text: $viewModel.password,
                                    placeholderText: "password",
                                    isTextGood: viewModel.passwordValidation,
                                    errorText: $viewModel.passwordError,
                                    viewModel: CustomTextFieldViewModel(nextButtonPressed: viewModel.loginButtonPressed),
                                    isTextFieldSecured: $viewModel.isTextFieldSecures,
                                    showEye: true
                                )
                                .frame(width: UIScreen.main.bounds.width / 1.3)
                                .padding(.trailing, 10)
                                
                            }
                            
                            Color("accent.blue")
                                .frame(height: 1)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 5)
                        }
                        .padding(.top, 20)
                        
                        
                        Button {
                            viewModel.loginButtonPressed.value = true
                            
                            dismissKeyboard()
                            
                            if (viewModel.emailValidation() && viewModel.passwordValidation() && !viewModel.canProcedSecondAuth) || !viewModel.sameCredentialsAsSnapshot() {
                                viewModel.canProcedSecondAuth = false
                                viewModel.loginButtonPressed.value = false
                                viewModel.verifyAvailableEmail()
                            } else if viewModel.canProcedSecondAuth && viewModel.sameCredentialsAsSnapshot() {
                                viewModel.loginButtonPressed.value = true
                                
                                dismissKeyboard()
                                
                                if viewModel.emailValidation() && viewModel.passwordValidation() {
                                    viewModel.loginButtonPressed.value = false
                                    self.navigation.push(
                                        AuthAdditionalView(viewModel: viewModel)
                                            .onDisappear {
                                                self.navigation.navigationController.interactivePopGestureRecognizer?.isEnabled = true
                                            }
                                            .asDestination(),
                                        animated: true
                                    )
                                    self.navigation.navigationController.interactivePopGestureRecognizer?.isEnabled = true
                                }
                            }
                            
                        } label: {
                            ZStack {
                                Color("accent.blue")
                                    .frame(height: 50)
                                    .cornerRadius(12)
                                
                                Text("Next")
                                    .foregroundColor(.white)
                                    .font(.asket(size: 20))
                            }
                        }
                        .padding(.top, 20)
                        
                        Spacer()
                        
                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(.white)
                                .font(.asket(size: 16))
                            
                            Button {
                                viewModel.clear()
                                navigation.pop(animated: true)
                                self.navigation.navigationController.interactivePopGestureRecognizer?.isEnabled = true
                            } label: {
                                Text("Login")
                                    .foregroundColor(Color("accent.blue"))
                                    .font(.asket(size: 20))
                            }
                            
                        }
                        .padding(.top, 10)
                        
                        
                        
                    }
                    .frame(width: proxy.size.width)
                    .frame(minHeight: proxy.size.height)
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
        .onChange(of: viewModel.canProcedSecondAuth, perform: { newValue in
            if newValue == true {
                viewModel.loginButtonPressed.value = true
                if viewModel.emailValidation() && viewModel.passwordValidation() {
                    viewModel.loginButtonPressed.value = false
                    self.navigation.push(
                        AuthAdditionalView(viewModel: viewModel)
                            .onDisappear {
                                self.navigation.navigationController.interactivePopGestureRecognizer?.isEnabled = false
                            }
                            .asDestination(),
                         animated: true
                    )
                    self.navigation.navigationController.interactivePopGestureRecognizer?.isEnabled = true
                }
                
                dismissKeyboard()
            }
        })
        .toast(
            isPresenting: $viewModel.showEmailALreadyExistsToast,
            duration: 10,
            tapToDismiss: true,
            alert: {
                AlertToast(
                    displayMode: .alert,
                    type: .systemImage("person", .white),
                    title: "Email alreay in use",
                    subTitle: "Tap to dismiss"
                )
            }
        )
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


struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(viewModel: LoginViewModel())
    }
}
