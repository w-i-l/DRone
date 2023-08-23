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
            
            BackButton(text: "Back")
            
            SearchingView(viewModel: viewModel.searchLocationViewModel)
            
            Spacer()
        }
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
