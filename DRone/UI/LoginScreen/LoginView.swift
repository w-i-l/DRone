
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
    
    private let navigation = SceneDelegate.mainNavigation
    @StateObject private var viewModel = LoginViewModel()
    
    let isPresentedAsFirstScreen: Bool
    
    init(isPresentedAsFirstScreen: Bool = true) {
        self.isPresentedAsFirstScreen = isPresentedAsFirstScreen
        navigation.navigationController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    var body: some View {
        
        VStack {
            
            if !isPresentedAsFirstScreen {
                BackButton(text: "Settings")
//                    .padding(.top, 30)
            }
            
            GeometryReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {


                        
                        LottieView(name: "FlyingDrone")
                            .lottieLoopMode(.autoReverse)
                            .frame(height: 200)
                            
                        Spacer()
                        
                        
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
                                    .frame(width: 20, height: 16)
                                
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
                            .padding(.top, 20)
                            
                        Spacer()
                        
                        // sign up
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
                        .padding(.vertical, 5)
                        
                            // separator
                            HStack {
                                Color("subtitle.gray")
                                    .frame(height: 1)
                                
                                Text("or")
                                    .foregroundColor(Color("subtitle.gray"))
                                    .font(.asket(size: 18))
                                
                                Color("subtitle.gray")
                                    .frame(height: 1)
                            }
                            .padding(.top, 5)
                            
                        

                        
                        // continue as guest
                            Button {
                                dismissKeyboard()
                                
                                viewModel.continueAsGuest()
                                
                            } label: {
                                ZStack {
                                    Color.clear
                                        .frame(height: 40)
                                        .cornerRadius(12)
                                    
                                    HStack {
                                        
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundColor(.white)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 16, height: 16)
                                        
                                        Text("Continue as guest")
                                            .foregroundColor(.white)
                                            .font(.asket(size: 16))
                                    }
                                }
                            }
                        

                        
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
//        .onReceive(viewModel.eventSubject, perform: { event in
//            switch event {
//            case .goToMainView:
//                navigation.push(MainView().asDestination(), animated: true)
//            default:
//                break
//            }
//        })
//        .onAppear {
//            viewModel.bind()
//        }
        .onTapGesture {
            dismissKeyboard()
        
            viewModel.clearToasts()
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


