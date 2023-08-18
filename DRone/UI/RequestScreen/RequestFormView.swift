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
    @ObservedObject private var navigation: Navigation
    
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
        
        self.navigation = SceneDelegate.navigation
    }
    
    var body: some View {
        
        VStack {
            HStack(spacing: 0) {
                ForEach(0..<view.count) { no in
                    GeometryReader { proxy in
                        VStack(spacing: 0){
                            if !viewModel.showNavigationLink {
                                BackButton(text: viewModel.screenIndex == 0 ? "Personal infos" : "Back", action:
                                            viewModel.screenIndex == 0 ? {dismiss()} : {AppService.shared.screenIndex.value -= 1}
                                )
                                
                                ProgressView(value: Float(viewModel.screenIndex) + 1, total: 4)
                                    .progressViewStyle(.linear)
                                    .accentColor(Color("accent.blue"))
                                    .padding(.top, 10)
                                    .padding(.bottom, 0)
                            }
                            
                            view[no]
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    
                }
                //                }
                .onChange(of: viewModel.screenIndex) { newValue in
                    
                    withAnimation(.none){
                        offset = UIScreen.main.bounds.width * CGFloat(newValue)
                    }
                    
                    if newValue == 0 {
                        navigation.navigationController.interactivePopGestureRecognizer?.isEnabled = true
                    } else {
                        navigation.navigationController.interactivePopGestureRecognizer?.isEnabled = false
                    }
                }
                .offset(x: view.count % 2 == 0 ? CGFloat(totalOffset) : 0)
                .offset(x: -offset)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
        .gesture(
            
                DragGesture()
                    .onEnded({ drag in
                        guard drag.startLocation.x <= 650 else { return }
                        guard viewModel.showNavigationLink == false else { return }
                        if viewModel.screenIndex > 0  {
                            withAnimation(.default) {
                                AppService.shared.screenIndex.value -= 1
                            }
                        } else {
                            navigation.pop(animated: true)
                        }
                    })
        )
    }
}

struct RequestFormView_Previews: PreviewProvider {
    static var previews: some View {
        RequestFormView(viewModel: RequestViewModel())
    }
}
