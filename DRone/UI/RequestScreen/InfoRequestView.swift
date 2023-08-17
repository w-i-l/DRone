
//
//  InfoRequestInfo.swift
//  DRone
//
//  Created by Mihai Ocnaru on 10.08.2023.
//

import SwiftUI

struct InfoRequestInfo: View {
    
    @ObservedObject var viewModel: RequestViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    
                    
                    // info
                    VStack(alignment: .leading) {
                        // request a flight
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("REQUEST")
                                    .font(.abel(size: 40))
                                    .foregroundColor(.white)
                                
                                Text("a flight")
                                    .font(.abel(size: 32))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        // steps
                        VStack(alignment: .leading, spacing: 24) {
                            ForEach([
                                (1, "Fill the form below"),
                                (2, "Wait for confirmation"),
                                (3, "You are ready to go!")
                            ], id: \.1) { item in
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 0.851, green: 0.851, blue: 0.851))
                                            .frame(width: 56, height: 56)
                                        
                                        Text("\(item.0)")
                                            .foregroundColor(Color("background.first"))
                                            .font(.abel(size: 36))
                                    }
                                    
                                    Text(item.1)
                                        .foregroundColor(.white)
                                        .font(.abel(size: 32))
                                }
                                
                            }
                        }
                        
                        // start button
                        HStack {
                            Spacer()
                            
                            NavigationLink(
                                destination:
                                    RequestFormView(viewModel: viewModel)
                                        .navigationBarBackButtonHidden(true)
                                , label: {
                                    ZStack {
                                        Color("accent.blue")
                                            .cornerRadius(20)
                                            .frame(width: 150, height: 50)
                                        
                                        HStack {
                                            Text("Start")
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
                                    .frame(width: 150, height: 50)
                                }
                            )
                            
                        }
                        
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    .background(
                        // drone Image
                        VStack(alignment: .trailing) {
                            HStack {
                                Spacer()
                                
                                Image("drone.image")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: UIScreen.main.bounds.width / 1)
                                    .offset(y: -60)
                            }
                            
                            Spacer()
                        }
                            .padding(.horizontal, 0)
                            .frame(maxWidth: .infinity)
                    )
                    
                }
                .padding(.bottom, UIScreen.main.bounds.height / 11.3)
                .frame(minHeight: proxy.size.height)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            )
            .navigationBarItems(leading:
                                    
                Button(action: {
                    dismiss()
            }) {
                VStack(alignment: .leading) {
                    HStack(spacing: 14) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 14, height: 14)
                            .scaledToFit()
                            .foregroundColor(.white)
                        
                        Text("All requests")
                            .font(.abel(size: 24))
                            .foregroundColor(.white)
                    }
                }
            })
        }
    }
}

struct InfoPersonal_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ZStack{
                InfoRequestInfo(viewModel: RequestViewModel())
                
                VStack {
                    Spacer()
                    TabBar()
                }
                .ignoresSafeArea()
            }
        }
        .navigationBarHidden(true)
    }
}

