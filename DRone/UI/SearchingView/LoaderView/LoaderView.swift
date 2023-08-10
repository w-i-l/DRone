//
//  LoaderView.swift
//  DRone
//
//  Created by Mihai Ocnaru on 09.08.2023.
//

import SwiftUI

struct LoaderView: View {
    
    @State private var progress: CGFloat = .zero
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: progress, to: progress + 0.2)
                .stroke(.white, lineWidth: 4)
                .onAppear {
                    withAnimation(.easeInOut.repeatForever(autoreverses: false)) {
                        progress = 1
                    }
            }
            
            ForEach(0..<10) { no in
                Circle()
                    .trim(from: progress, to: progress + 0.2)
                    .stroke(.white, lineWidth: 4)
                    .onAppear {
                        withAnimation(.easeInOut.repeatForever(autoreverses: false)) {
                            progress = 1
                        }
                }
                    .scaleEffect(CGFloat(no) * CGFloat(0.1))
            }
        }
            
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom)
            )
    }
}
