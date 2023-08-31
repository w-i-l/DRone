//
//  DroneInformation.swift
//  DRone
//
//  Created by Mihai Ocnaru on 16.08.2023.
//

import SwiftUI
import BottomSheet

struct DroneInformation: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: RequestViewModel
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Drone information")
                            .font(.asket(size: 32))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        Text("Complete the form with your drone information")
                            .font(.asket(size: 16))
                            .foregroundColor(Color("subtitle.gray"))
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    VStack {
                        // serial number
                        VStack(alignment: .leading, spacing: 7) {
                            Text("Serial number")
                                .foregroundColor(Color("subtitle.gray"))
                                .font(.asket(size: 18))
                            
                            CustomTextField(
                                text: $viewModel.serialNumber,
                                placeholderText: "Serial number",
                                isTextGood: {
                                    viewModel.serialNumberValidation()
                                },
                                errorText: $viewModel.serialNumberError,
                                viewModel: CustomTextFieldViewModel(nextButtonPressed: viewModel.droneNextButtonPressed)
                            )
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                        
                        // drone type
                        VStack(alignment: .leading, spacing: 7) {
                            Text("Drone type")
                                .foregroundColor(Color("subtitle.gray"))
                                .font(.asket(size: 18))
                            
                            Button(
                                action: {
                                    dismissKeyboard()
                                    viewModel.isDroneModalShown = true
                                    viewModel.bottomSheetPosition = .relativeTop(0.7)
                            }, label: {
                                HStack(spacing: 14) {
                                    Circle()
                                        .fill(Color("accent.blue"))
                                        .frame(width: 16, height: 16)
                                    
                                    Text("\(viewModel.droneType.associatedValues.type) drone")
                                        .foregroundColor(.white)
                                        .font(.asket(size: 16))
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                        .frame(width: 12, height: 12)
                                        .scaledToFit()
                                }
                                .padding(.vertical, 15)
                                .padding(.horizontal, 10)
                                .background(Color("gray.background").cornerRadius(12))
                            })
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
                            viewModel.droneNextButtonPressed.value = true
                            self.dismissKeyboard()
                            
                            if viewModel.serialNumberValidation(){
                                AppService.shared.screenIndex.value = 3
                                viewModel.droneNextButtonPressed.value = false
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
        .ignoresSafeArea(.keyboard)
        .navigationBarTitleDisplayMode(.inline)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
        .bottomSheet(
            bottomSheetPosition: $viewModel.bottomSheetPosition,
            switchablePositions: [.relativeTop(0.7)],
            content: {
                DroneTypeModal(viewModel: viewModel)
            })
        .enableSwipeToDismiss()
        .enableTapToDismiss()
        .onTapGesture {
            dismissKeyboard()
        }
    }
}

struct DroneInformation_Previews: PreviewProvider {
    static var previews: some View {
        DroneInformation(viewModel: RequestViewModel())
    }
}
