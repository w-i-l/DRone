//
//  PersonalInfosRequest.swift
//  DRone
//
//  Created by Mihai Ocnaru on 10.08.2023.
//

import SwiftUI

struct PersonalInfosRequest: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: RequestViewModel
    
    var body: some View {
        VStack {
            
            GeometryReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            
                            Text("Personal information")
                                .font(.asket(size: 36))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            
                            Text("Complete the form with your personal information")
                                .font(.asket(size: 16))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            VStack {
                                // full name
                                VStack(alignment: .leading, spacing: 7) {
                                    Text("Full name")
                                        .foregroundColor(.white)
                                        .font(.asket(size: 20))
                                    
                                    
                                    // first name
                                    CustomTextField(
                                        text: $viewModel.firstName,
                                        placeholderText: "First name",
                                        isTextGood: viewModel.firstNameValidation,
                                        errorText:  $viewModel.firstNameError,
                                        viewModel: CustomTextFieldViewModel(nextButtonPressed: viewModel.personalNextButtonPressed)
                                    )
                                    
                                    // last name
                                    CustomTextField(
                                        text: $viewModel.lastName,
                                        placeholderText: "Last name",
                                        isTextGood: viewModel.lastNameValidation,
                                        errorText: $viewModel.lastNameError,
                                        viewModel: CustomTextFieldViewModel(nextButtonPressed: viewModel.personalNextButtonPressed)
                                    )
                                    .padding(.top, 9)
                                }
                                .padding(.top, 40)
                                
                                // CNP
                                VStack(alignment: .leading, spacing: 7) {
                                    Text("Personal identification number")
                                        .foregroundColor(.white)
                                        .font(.asket(size: 20))
                                    
                                
                                    // first name
                                    CustomTextField(
                                        text: $viewModel.CNP,
                                        placeholderText: "CNP",
                                        isTextGood: viewModel.cnpValidation,
                                        errorText: $viewModel.cnpError,
                                        viewModel: CustomTextFieldViewModel(nextButtonPressed: viewModel.personalNextButtonPressed),
                                        keyboardType: .numberPad
                                    )
                                }
                                .padding(.top, 32)
                            }
                            // progress
                                
                            Spacer()
                            
                            HStack {
                                Spacer()
                                Button {
                                    
                                    viewModel.personalNextButtonPressed.value = true
                                    
                                    if viewModel.onlyStringValidation(string: viewModel.firstName) &&
                                        viewModel.onlyStringValidation(string: viewModel.lastName) &&
                                        viewModel.personalNumberValidation(personalNumber: viewModel.CNP) &&
                                        viewModel.getBirthDayFromCNP() != nil {
                                        
                                        viewModel.personalNextButtonPressed.value = false
                                        AppService.shared.screenIndex.value = 1
                                        viewModel.birthdayDate = viewModel.getBirthDayFromCNP()!
                                    }
                                    self.dismissKeyboard()
                                        
                                    } label: {
                                        ZStack {
                                            Color("accent.blue")
                                                .cornerRadius(20)
                                                .frame(height: 50)
                                            
                                            HStack {
                                                Text("Next")
                                                    .foregroundColor(.white)
                                                    .font(.asket(size: 32))
                                                
                                                Spacer()
                                                
                                                Image(systemName: "chevron.right")
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .foregroundColor(.white)
                                                    .frame(width: 18, height: 18)
                                                    .scaledToFit()
                                            }
                                            .padding(15)
                                        }
                                        .frame(width: 150 ,height: 50)
                                    }
                                .padding(.top, UIScreen.main.bounds.height / 20)
                                
                                Spacer()
                            }
                            
                            
                        }
                        .padding(.horizontal, 20)
                        .frame(minHeight: proxy.size.height)
                    }
                    .frame(maxHeight: .infinity)
            }
        }
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
        .onTapGesture {
            dismissKeyboard()
        }
    }
}

struct PersonalInfosRequest_Previews: PreviewProvider {
    static var previews: some View {
        PersonalInfosRequest(viewModel: RequestViewModel())
   }
}
