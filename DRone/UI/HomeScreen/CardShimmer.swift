//
//  CardShimmer.swift
//  DRone
//
//  Created by Mihai Ocnaru on 08.08.2023.
//

import SwiftUI

struct CardShimmer: View {
    
    let firstGrayColor = Color(red: 0.85, green: 0.85, blue: 0.85)
    let secondGrayColor = Color(red: 0.8, green: 0.8, blue: 0.8)
    let thirdGrayColot = Color(red: 0.75, green: 0.75, blue: 0.75)
    let fourthGrayColor = Color(red: 0.7, green: 0.7, blue: 0.7)
    let finalGrayColor = Color(red: 0.55, green: 0.55, blue: 0.55)


    let gradients: [Gradient]
    
    @State private var gradient: LinearGradient
    @State private var gradientIndex = 0
    @State private var progress: CGFloat = 0.0
    
    @StateObject private var viewModel = BaseViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            
            
            gradient
                .modifier(AnimatableGradientModifier(fromGradient: gradients[gradientIndex], toGradient: gradients[(gradientIndex + 1) % gradients.count], progress: progress))

           
        }
        .overlay (
            RoundedRectangle(cornerRadius: 0)
                .stroke(Color(red: 0.922, green: 0.922, blue: 0.922))
        )
        .onAppear {
            Timer.publish(every: 0.4, on: .current, in: .common)
                .autoconnect()
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    withAnimation(.easeInOut.repeatForever(autoreverses: true)){
                        gradientIndex += 1
                        gradientIndex = gradientIndex % (gradients.count - 1)
//                        gradient = gradients[gradientIndex]
                        progress = 1
                    }
                }
                .store(in: &viewModel.bag)
        }
    }
    
    init() {
        gradient = LinearGradient(
            colors: [firstGrayColor, finalGrayColor],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        gradients = [
            Gradient(stops: [
                .init(color: finalGrayColor, location: 0),
                .init(color: fourthGrayColor, location: 1)
            ]),
//            Gradient(stops: [
//                .init(color: firstGrayColor, location: 0),
//                .init(color: finalGrayColor, location: 1)
//            ]),
            Gradient(stops: [
                .init(color: finalGrayColor, location: 0),
                .init(color: finalGrayColor, location: 0.25),
                .init(color: finalGrayColor, location: 0.5),
                .init(color: fourthGrayColor, location: 0.75),
                .init(color: fourthGrayColor, location: 1)
            ])
//            Gradient(stops: [
//                .init(color: firstGrayColor, location: 0),
//                .init(color: firstGrayColor, location: 0.25),
//                .init(color: firstGrayColor, location: 0.5),
//                .init(color: fourthGrayColor, location: 0.75),
//                .init(color: finalGrayColor, location: 1)
//            ]),
//            Gradient(stops: [
//                .init(color: firstGrayColor, location: 0),
//                .init(color: firstGrayColor, location: 0.25),
//                .init(color: firstGrayColor, location: 0.5),
//                .init(color: firstGrayColor, location: 0.75),
//                .init(color: finalGrayColor, location: 1)
//            ]),
//            Gradient(stops: [
//                .init(color: firstGrayColor, location: 0),
//                .init(color: firstGrayColor, location: 0.25),
//                .init(color: firstGrayColor, location: 0.5),
//                .init(color: firstGrayColor, location: 0.75),
//                .init(color: firstGrayColor, location: 1)
//            ])
        ]
    }
}

struct CardShimmer_Previews: PreviewProvider {
    static var previews: some View {
        CardShimmer()
    }
}
