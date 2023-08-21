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
                                .font(.abel(size: 40))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            
                            Text("Complete the form with your personal information")
                                .font(.abel(size: 18))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            VStack {
                                // full name
                                VStack(alignment: .leading, spacing: 7) {
                                    Text("Full name")
                                        .foregroundColor(.white)
                                        .font(.abel(size: 20))
                                    
                                    
                                    // first name
                                    CustomTextField(
                                        text: $viewModel.firstName,
                                        placeholderText: "First name...",
                                        isTextGood: {
                                            viewModel.onlyStringValidation(string: viewModel.firstName)
                                        },
                                        errorText: "Enter a valid last name",
                                        viewModel: CustomTextFieldViewModel(nextButtonPressed: viewModel.personalNextButtonPressed)
                                    )
                                    
                                    // last name
                                    CustomTextField(
                                        text: $viewModel.lastName,
                                        placeholderText: "Last name...",
                                        isTextGood: {
                                            viewModel.onlyStringValidation(string: viewModel.lastName)
                                        },
                                        errorText: "Enter a valid first name",
                                        viewModel: CustomTextFieldViewModel(nextButtonPressed: viewModel.personalNextButtonPressed)
                                    )
                                }
                                .padding(.top, 40)
                                
                                // CNP
                                VStack(alignment: .leading, spacing: 7) {
                                    Text("Personal identification number")
                                        .foregroundColor(.white)
                                        .font(.abel(size: 20))
                                    
                                
                                    // first name
                                    CustomTextField(
                                        text: $viewModel.CNP,
                                        placeholderText: "CNP",
                                        isTextGood: {
                                            viewModel.personalNumberValidation(personalNumber: viewModel.CNP)
                                        },
                                        errorText: "The personal number shoudl have 13 digits",
                                        viewModel: CustomTextFieldViewModel(nextButtonPressed: viewModel.personalNextButtonPressed)
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
                                        viewModel.personalNumberValidation(personalNumber: viewModel.CNP) {
                                        viewModel.personalNextButtonPressed.value = false
                                        AppService.shared.screenIndex.value = 1
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
                                                    .font(.abel(size: 32))
                                                
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
    }
}

struct PersonalInfosRequest_Previews: PreviewProvider {
    static var previews: some View {
        PersonalInfosRequest(viewModel: RequestViewModel())
   }
}
