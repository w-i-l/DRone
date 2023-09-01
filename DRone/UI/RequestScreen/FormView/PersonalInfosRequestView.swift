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
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Personal information")
                                    .font(.asket(size: 32))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                
                                Text("Complete the form with your personal information")
                                    .font(.asket(size: 16))
                                    .foregroundColor(Color("subtitle.gray"))
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.top, 10)
                            
                            
                            Spacer()
                            
                            VStack {
                                // full name
                                VStack(alignment: .leading, spacing: 7) {
                                    Text("Full name")
                                        .foregroundColor(Color("subtitle.gray"))
                                        .font(.asket(size: 18))
                                    
                                    
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
                                    Text("Personal number")
                                        .foregroundColor(Color("subtitle.gray"))
                                        .font(.asket(size: 18))
                                    
                                
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
                            
                            // next button
                            HStack {
                                Spacer()
                                
                                Button (action: {
                                    
                                    viewModel.personalNextButtonPressed.value = true
                                    self.dismissKeyboard()
                                    
                                    if viewModel.firstNameValidation() &&
                                        viewModel.lastNameValidation() &&
                                        viewModel.cnpValidation() &&
                                        viewModel.getBirthDayFromCNP() != nil {
                                        
                                        viewModel.personalNextButtonPressed.value = false
                                        AppService.shared.screenIndex.value = 1
                                        viewModel.birthdayDate = viewModel.getBirthDayFromCNP()!
                                    }
                                    
                                }, label: {
                                    ZStack {
                                        Color("accent.blue")
                                            .cornerRadius(12)
                                            .frame(height: 60)
                                        
                                        HStack {
                                            Text("Next")
                                                .foregroundColor(.white)
                                                .font(.asket(size: 24))
                                            
//                                            Image(systemName: "chevron.right")
//                                                .resizable()
//                                                .renderingMode(.template)
//                                                .foregroundColor(.white)
//                                                .frame(width: 10, height: 10)
//                                                .scaledToFit()
                                        }
                                        .padding(.vertical, 10)
                                    }
                                })
                                
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
