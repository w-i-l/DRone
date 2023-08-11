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
                                        return true
                                    }
                                )
                                
                                // last name
                                CustomTextField(
                                    text: $viewModel.lastName,
                                    placeholderText: "Last name...",
                                    isTextGood: {
                                        return true
                                    }
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
                                        return true
                                    }
                                )
                            }
                            .padding(.top, 32)
                        }
                        // progress
                            
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Button {
                                    // hardcoded the number of screens
                                    if AppService.shared.screenIndex.value < 3 {
                                        AppService.shared.screenIndex.value += 1
                                    }
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
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding(.bottom, UIScreen.main.bounds.height / 11.3)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
        
        .navigationBarItems(leading:
                                
                                Button(action: {
            dismiss()
        }) {
            HStack(spacing: 14) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 14, height: 14)
                    .scaledToFit()
                    .foregroundColor(.white)
                
                Text("Request Page")
                    .font(.abel(size: 24))
                    .foregroundColor(.white)
            }
        })
    }
}

struct PersonalInfosRequest_Previews: PreviewProvider {
    static var previews: some View {
        PersonalInfosRequest(viewModel: RequestViewModel())
   }
}
