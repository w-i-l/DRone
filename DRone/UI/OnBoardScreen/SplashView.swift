//
//  SplashView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 04.09.2023.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            
            Spacer()
            
            Image("logo")
                .resizable()
                .frame(width: 150, height: 150)
            
            Text("DRone")
                .font(.asket(size: 32))
                .foregroundColor(.white)
            
            Spacer()
            
            Text("Your friend up in the")
                .font(.asket(size: 24))
                .foregroundColor(.white)
            
            Text("SKY")
                .font(.asket(size: 32))
                .foregroundColor(Color("accent.blue"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
