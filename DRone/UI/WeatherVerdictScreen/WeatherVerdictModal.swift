//
//  WeatherVerdictModal.swift
//  DRone
//
//  Created by Mihai Ocnaru on 28.08.2023.
//

import SwiftUI

struct WeatherVerdictModal: View {
    
    let weatherVerdictModalModel: WeatherVerdictModalModel
    let condition: (isIdeal: Bool, isGood: Bool)
    
    var body: some View {
        
        ScrollView {
            VStack {
                
                Text(weatherVerdictModalModel.title)
                    .foregroundColor(.white)
                    .font(.asket(size: 24))
                
                VStack(spacing: 0) {
                    
                    // current
                    HStack {
                        
                        HStack {
                            Text("Current")
                                .foregroundColor(.white)
                                .font(.asket(size: 18))
                            
                            Spacer()
                            
                            if condition.isIdeal{
                                
                                Circle()
                                    .fill(Color("green"))
                                    .frame(width: 16)
                            } else if condition.isGood {
                                
                                Circle()
                                    .fill(Color("yellow"))
                                    .frame(width: 16)
                            } else {
                                
                                Circle()
                                    .fill(Color("red"))
                                    .frame(width: 16)
                            }
                        }
                        .frame(width: 100)
                        
                        Spacer()
                        
                        Text("\(weatherVerdictModalModel.current)\(weatherVerdictModalModel.format)")
                            .foregroundColor(.white)
                            .font(.asket(size: 18))
                    }
                    .padding(.top, 20)
                    
                    // ideal, good, bad
                    VStack(spacing: 10) {
                        ForEach([
                            ("Ideal", Color("green"), "\(weatherVerdictModalModel.ideal)\(weatherVerdictModalModel.format)"),
                            ("Good", Color("yellow"), "\(weatherVerdictModalModel.good)\(weatherVerdictModalModel.format)"),
                            ("Bad", Color("red"), "\(weatherVerdictModalModel.bad)\(weatherVerdictModalModel.format)")
                        ], id: \.0) { item in
                            HStack {
                                
                                HStack {
                                    Text(item.0)
                                        .foregroundColor(.white)
                                        .font(.asket(size: 18))
                                    
                                    Spacer()
                                    
                                    Circle()
                                        .fill(item.1)
                                        .frame(width: 16, height: 16)
                                    
                                }
                                .frame(width: 100)
                                
                                Spacer()
                                
                                Text(item.2)
                                    .foregroundColor(.white)
                                    .font(.asket(size: 18))                                    
                            }
                        }
                    }
                    .padding(.top, 32)
                }
                .padding(.top, 20)
            }
            .padding(20)
        }
        .background(Color("background.first"))
    }
}

struct WeatherVerdictModal_Previews: PreviewProvider {
    static var previews: some View {
        WeatherVerdictModal(weatherVerdictModalModel: WeatherVerdictModalModel(
            title: "Precipitation probability",
            current: 2,
            ideal: 4,
            good: 2,
            bad: "< 2",
            format: "%"
        ),
        condition: (true, false)
        )
    }
}
