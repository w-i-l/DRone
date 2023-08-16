//
//  AdditionalPersonalInformationView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 11.08.2023.
//

import SwiftUI

struct AdditionalPersonalInformationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: RequestViewModel
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("Additional information")
                        .font(.abel(size: 40))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Text("Complete the form with your personal information")
                        .font(.abel(size: 18))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    VStack {
                        // birthday
                        VStack(alignment: .leading, spacing: 7) {
                            Text("Birthday")
                                .foregroundColor(.white)
                                .font(.abel(size: 20))
                            
                            HStack {
                                Text("Date")
                                    .foregroundColor(.white)
                                    .font(.abel(size: 20))
                                
                                Spacer()
                                
                                DatePicker(selection: $viewModel.birthdayDate,
                                           in: Date()...,
                                           displayedComponents: .date) {
                                    Text("Date")
                                        .foregroundColor(.white)
                                        .font(.abel(size: 20))
                                }
                                           .labelsHidden()
                                           .colorInvert()
                                           .colorMultiply(Color.white)
                                           .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                                           .colorScheme(.light)
                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                        
                        // current location
                        VStack(alignment: .leading, spacing: 7) {
                            Text("Your current location")
                                .foregroundColor(.white)
                                .font(.abel(size: 20))
                            
                            HStack(spacing: 14) {
                                Image(systemName: "mappin.circle")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                                    .scaledToFit()
                                
                                VStack(spacing: 4) {
                                    Text(viewModel.currentLocation.mainAdress.limitLettersFormattedString(limit: 30))
                                        .foregroundColor(.white)
                                        .font(.abel(size: 16))
                                    
                                    Text(viewModel.currentLocation.secondaryAdress.limitLettersFormattedString(limit: 30))
                                        .foregroundColor(Color("subtitle.gray"))
                                        .font(.abel(size: 12))
                                    
                                }
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
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
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
    }
}

struct AdditionalPersonalInformationView_Previews: PreviewProvider {
    static var previews: some View {
        AdditionalPersonalInformationView(viewModel: RequestViewModel())
    }
}
