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
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Additional information")
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
                        // birthday
                        VStack(alignment: .leading, spacing: 7) {
                            
                            HStack {
                                Text("Birthday")
                                    .foregroundColor(Color("subtitle.gray"))
                                    .font(.asket(size: 18))
                                
                                Spacer()
                                
                                DatePicker(selection: $viewModel.birthdayDate,
                                           in: (Date() - viewModel.minimumBirthdayDate)...(Date() - viewModel.maximumBirthdayDate),
                                           displayedComponents: .date) {
                                    Text("Date")
                                        .foregroundColor(.white)
                                        .font(.asket(size: 20))
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
                                .foregroundColor(Color("subtitle.gray"))
                                .font(.asket(size: 18))
                            
                            HStack(spacing: 14) {
                                Image("map.pin")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                                    .scaledToFit()
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(viewModel.currentLocation.mainAddress.limitLettersFormattedString(limit: 30))
                                        .foregroundColor(.white)
                                        .font(.asket(size: 16))
                                    
                                    Text(viewModel.currentLocation.secondaryAddress.limitLettersFormattedString(limit: 30))
                                        .foregroundColor(Color("subtitle.gray"))
                                        .font(.asket(size: 12))
                                    
                                }
                                Spacer()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.white, lineWidth: 1)
                                    .padding(-10)
                            )
                            .padding(10)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 32)
                    }
                    // progress
                    
                    Spacer()
                    
                    // next button
                    HStack {
                        Spacer()
                        
                        Button (action: {
                            AppService.shared.screenIndex.value = 2 
                        }, label: {
                            ZStack {
                                Color("accent.blue")
                                    .cornerRadius(12)
                                    .frame(height: 60)
                                
                                HStack {
                                    Text("Next")
                                        .foregroundColor(.white)
                                        .font(.asket(size: 24))
                                    
//                                    Image(systemName: "chevron.right")
//                                        .resizable()
//                                        .renderingMode(.template)
//                                        .foregroundColor(.white)
//                                        .frame(width: 10, height: 10)
//                                        .scaledToFit()
                                }
                                .padding(.vertical, 10)
                            }
                        })
                        
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
