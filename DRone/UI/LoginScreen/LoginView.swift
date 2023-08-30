
//
//  LoginView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 29.08.2023.
//

import SwiftUI
import LottieSwiftUI
import AlertToast

struct LoginView: View {
    
    @StateObject var viewModel: LoginViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {

                LottieView(name: "FlyingDrone")
                    .lottieLoopMode(.autoReverse)
                    .frame(width: UIScreen.main.bounds.width, height: 300)
                
                
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Login")
                            .foregroundColor(.white)
                            .font(.asket(size: 36))
                        
                        Text("Enter you email and password")
                            .foregroundColor(.white)
                            .font(.asket(size: 20))
                    }
                    
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                // email and password
                VStack(spacing: 4) {
                    
                    HStack(spacing: 10) {
                        Image(systemName: "envelope")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 15)
                            .scaledToFit()
                        
                        Color("accent.blue")
                            .frame(width: 1, height: 40)
                        
                        CustomTextField(
                            text: $viewModel.email,
                            placeholderText: "email",
                            isTextGood: viewModel.emailValidation,
                            errorText: $viewModel.emailError,
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
                        Image(systemName: "lock")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .scaledToFit()
                        
                        Color("accent.blue")
                            .frame(width: 1, height: 40)
                        
                        CustomTextField(
                            text: $viewModel.password,
                            placeholderText: "password",
                            isTextGood: viewModel.passwordValidation,
                            errorText: $viewModel.passwordError,
                            viewModel: CustomTextFieldViewModel(nextButtonPressed: viewModel.loginButtonPressed),
                            isTextFieldSecured: $viewModel.isTextFieldSecures
                            
                        )
                        .frame(width: UIScreen.main.bounds.width / 1.5)
                        .padding(.trailing, 10)
                        
                        Button {
                            viewModel.isTextFieldSecures.toggle()
                        } label: {
                            Image(systemName: viewModel.isTextFieldSecures ? "eye.slash.fill" : "eye")
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
                }
                .padding(.top, 40)
                
                // remember me toggle
                HStack {
                    
                    Toggle(
                        isOn: $viewModel.rememberMe) {
                        }
                        .frame(width: 70)
                    
                    Text("Remember me")
                        .foregroundColor(.white)
                        .font(.asket(size: 16))
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                

                Spacer()
                
                HStack {
                    Button {
                        viewModel.loginButtonPressed.value = true
                        dismissKeyboard()
                        
                        viewModel.login()
                        
                    } label: {
                        ZStack {
                            Color("accent.blue")
                                .frame(height: 50)
                                .cornerRadius(12)
                            
                            Text("Login")
                                .foregroundColor(.white)
                                .font(.asket(size: 20))
                        }
                    }
                    
                    Button {
                        dismissKeyboard()
                        
                        viewModel.continueAsGuest()
                        
                    } label: {
                        ZStack {
                            Color.white
                                .frame(height: 50)
                                .cornerRadius(12)
                            
                            HStack {
                                
                                Image(systemName: "person")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color("background.first"))
                                    .frame(width: 16, height: 16)
                                    .scaledToFit()
                                
                                Text("Continue as guest")
                                    .foregroundColor(Color("background.first"))
                                .font(.asket(size: 16))
                            }
                        }
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal, 20)
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.white)
                        .font(.asket(size: 16))
                    
                    Button {
                        viewModel.goToAuth()
                    } label: {
                        Text("Sign up")
                            .foregroundColor(Color("accent.blue"))
                            .font(.asket(size: 20))
                    }

                }
                .padding(.top, 10)

                
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
        .toast(
            isPresenting: $viewModel.showWrongPasswordToast,
            duration: 10,
            tapToDismiss: true,
            alert: {
                AlertToast(
                    displayMode: .alert,
                    type: .error(.red),
                    title: "Wrong password",
                    subTitle: "Tap to dimiss"
                )
            }
        )
        .toast(
            isPresenting: $viewModel.showTooManyRequestsToast,
            duration: 10,
            tapToDismiss: true,
            alert: {
                AlertToast(
                    displayMode: .alert,
                    type: .systemImage("exclamationmark.triangle", .yellow),
                    title: "Too many requests",
                    subTitle: "Please wait 3 minutes."
                )
            }
        )
        .toast(
            isPresenting: $viewModel.showEmailNotVerifiedToast,
            duration: 10,
            tapToDismiss: true,
            alert: {
                AlertToast(
                    displayMode: .alert,
                    type: .systemImage("envelope", .white),
                    title: "Please verify your email",
                    subTitle: "A request was sent!"
                )
            }
        )
        .toast(
            isPresenting: $viewModel.showNoUserFoundToast,
            duration: 10,
            tapToDismiss: true,
            alert: {
                AlertToast(
                    displayMode: .alert,
                    type: .systemImage("person.fill.xmark", .red),
                    title: "No user found",
                    subTitle: "Please create an account first!"
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}