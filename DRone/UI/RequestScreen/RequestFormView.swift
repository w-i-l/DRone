//
//  RequestFormView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 11.08.2023.
//

import SwiftUI

struct RequestFormView: View {
    
    let view: [some View] = [
        PersonalInfosRequest(viewModel: RequestViewModel()),
        PersonalInfosRequest(viewModel: RequestViewModel()),
        PersonalInfosRequest(viewModel: RequestViewModel()),
        PersonalInfosRequest(viewModel: RequestViewModel())
    ]
    @State var offset: CGFloat = 0
    @ObservedObject var viewModel: RequestViewModel
    
    let noOfItemsOffset: Int
    let totalOffset:CGFloat
    
    init(viewModel: RequestViewModel) {
        self.viewModel = viewModel
        noOfItemsOffset = ((view.count - 2) / 2)
        totalOffset = CGFloat(UIScreen.main.bounds.width * (CGFloat(noOfItemsOffset) + 0.5))
    }
    
    var body: some View {
        
        HStack(spacing: 0) {
            ForEach(0..<view.count) { no in
                GeometryReader { proxy in
                    view[no]
                }
                .frame(width: UIScreen.main.bounds.width)
            }
            //                }
            .onChange(of: viewModel.screenIndex) { newValue in
                offset = UIScreen.main.bounds.width * CGFloat(newValue)
            }
            .offset(x: view.count % 2 == 0 ? CGFloat(totalOffset) : 0)
            .offset(x: -offset)
        }
        .onAppear {
            AppService.shared.screenIndex.value = 0
        }
        //            .disabled(true)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct RequestFormView_Previews: PreviewProvider {
    static var previews: some View {
        RequestFormView(viewModel: RequestViewModel())
    }
}
