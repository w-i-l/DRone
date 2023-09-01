//
//  NoLocationModal.swift
//  DRone
//
//  Created by Mihai Ocnaru on 01.09.2023.
//

import SwiftUI
import LottieSwiftUI

struct NoServiceModal: View {
    
    let title: String
    let lottieName: String
    let text: String
    
    var body: some View {
        VStack {
            
            Text(title)
                .foregroundColor(Color("red"))
                .font(.asket(size: 32))
            
            
            LottieView(name: lottieName)
                .lottieLoopMode(.autoReverse)
                .frame(width: 200, height: 200)
            
            Text(text)
                .foregroundColor(.white)
                .font(.asket(size: 20))
                .lineLimit(2)
                .frame(width: 300)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            } label: {
                
                ZStack {
                    
                    Color("accent.blue")
                        .cornerRadius(12)
                        .frame(width: 200)
                        .frame(height: 55)
                    
                    Text("Go to settings")
                        .foregroundColor(.white)
                        .font(.asket(size: 16))
                        .padding(10)
                        
                }
            }
            .padding(.vertical, 20)

        }
    }
}

struct NoLocationModal_Previews: PreviewProvider {
    static var previews: some View {
        NoServiceModal(
            title: "No location found",
            lottieName: "NoLocation",
            text: "Please enable location from settings"
        )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("background.first"))
            .edgesIgnoringSafeArea(.all)
    }
}
