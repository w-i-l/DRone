//
//  RequestFormView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 11.08.2023.
//

import SwiftUI

struct RequestFormView: View {
    
    let view: [AnyView]
    
    @State var offset: CGFloat = 0
    @ObservedObject var viewModel: RequestViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    let noOfItemsOffset: Int
    let totalOffset:CGFloat
    
    init(viewModel: RequestViewModel) {
        self.viewModel = viewModel
        
        self.view = [
            AnyView(PersonalInfosRequest(viewModel: viewModel)),
            AnyView(AdditionalPersonalInformationView(viewModel: viewModel)),
            AnyView(DroneInformation(viewModel: viewModel)),
            AnyView(FlightInformation(viewModel: viewModel))
        ]
        
        noOfItemsOffset = ((view.count - 2) / 2)
        totalOffset = CGFloat(UIScreen.main.bounds.width * (CGFloat(noOfItemsOffset) + 0.5))
    }
    
    var body: some View {
        
        HStack(spacing: 0) {
            ForEach(0..<view.count) { no in
                GeometryReader { proxy in
                    VStack(spacing: 0){
                        ProgressView(value: Float(viewModel.screenIndex) + 1, total: 4)
                            .progressViewStyle(.linear)
                            .accentColor(Color("accent.blue"))
                        
                        view[no]
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                
            }
            //                }
            .onChange(of: viewModel.screenIndex) { newValue in
                print(newValue)
                offset = UIScreen.main.bounds.width * CGFloat(newValue)
            }
            .offset(x: view.count % 2 == 0 ? CGFloat(totalOffset) : 0)
            .offset(x: -offset)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
        .navigationBarItems(leading:
                                
                                Button(action: {
            if viewModel.screenIndex >= 1 {
                AppService.shared.screenIndex.value -= 1
            } else if viewModel.screenIndex == 0 {
                dismiss()
            }
        }) {
            VStack(alignment: .leading) {
                HStack(spacing: 14) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 14, height: 14)
                        .scaledToFit()
                        .foregroundColor(.white)
                    
                    Text(viewModel.screenIndex == 0 ? "Personal infos" : "Back")
                        .font(.abel(size: 24))
                        .foregroundColor(.white)
                }
            }
        })
    }
}

struct RequestFormView_Previews: PreviewProvider {
    static var previews: some View {
        RequestFormView(viewModel: RequestViewModel())
    }
}
