//
//  DroneTypeModa;.swift
//  DRone
//
//  Created by Mihai Ocnaru on 16.08.2023.
//

import SwiftUI

struct DroneTypeModal: View {
    
    @ObservedObject var viewModel: RequestViewModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 24) {
            ForEach(DroneType.allCases, id: \.self) { type in
                Button(
                    action: {
                        viewModel.droneType = type
                        viewModel.bottomSheetPosition = .hidden
                    }, label: {
                    HStack(spacing: 18) {
                        Group {
                            if viewModel.droneType == type {
                                Circle()
                                    .fill(Color("accent.blue"))
                            } else {
                                Circle()
                                    .strokeBorder(Color("accent.blue"))
                            }
                        }
                        .frame(width: 18, height: 18)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(type.associatedValues.type) drone")
                                .foregroundColor(.white)
                                .font(.asket(size: 18))
                            
                            Text("\(type.associatedValues.weight.lowerBound.roundToOneDecimal()) - \(type.associatedValues.weight.upperBound.roundToOneDecimal()) kg")
                                .foregroundColor(Color("subtitle.gray"))
                                .font(.asket(size: 18))
                        }
                        .padding(.vertical, 5)
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 10)
                    .background(Color("gray.background").cornerRadius(12))
                })
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("background.first").ignoresSafeArea())
    }
}

struct DroneTypeModa__Previews: PreviewProvider {
    static var previews: some View {
        DroneTypeModal(viewModel: RequestViewModel())
    }
}
