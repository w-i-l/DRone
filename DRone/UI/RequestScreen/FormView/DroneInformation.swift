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
                    
                    Text("Drone information")
                        .font(.asket(size: 36))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Text("Complete the form with your drone information")
                        .font(.asket(size: 16))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    VStack {
                        // serial number
                        VStack(alignment: .leading, spacing: 7) {
                            Text("Serial number")
                                .foregroundColor(.white)
                                .font(.asket(size: 20))
                            
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
                                .foregroundColor(.white)
                                .font(.asket(size: 20))
                            
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
                                        .font(.asket(size: 18))
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                        .frame(width: 12, height: 12)
                                        .scaledToFit()
                                }
                                .padding(10)
                                .background(Color("gray.background").cornerRadius(12))
                            })
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 32)
                    }
                    // progress
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button {
                            viewModel.droneNextButtonPressed.value = true
                            
                            if viewModel.serialNumberValidation(){
                                AppService.shared.screenIndex.value = 3
                                viewModel.droneNextButtonPressed.value = false
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
        }
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
