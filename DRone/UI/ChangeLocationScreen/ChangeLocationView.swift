//
//  ChangeLocationView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 10.08.2023.
//

import SwiftUI
import CoreLocation

struct ChangeLocationView: View {
    
    @StateObject var viewModel: ChangeLocationViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            SearchingView(viewModel: viewModel.searchLocationViewModel)
        }
        .navigationBarItems(leading:
            Button {
                dismiss()
            } label: {
                HStack(spacing: 14) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 14, height: 14)
                        .scaledToFit()
                        .foregroundColor(.white)
                    
                    
                    Text("Back")
                        .font(.abel(size: 24))
                        .foregroundColor(.white)
                }
            }
        )
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
    }
}

struct ChangeLocationView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeLocationView(viewModel: ChangeLocationViewModel(adressToFetchLocation: .constant(CLLocationCoordinate2D())))
    }
}
