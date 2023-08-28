//
//  NoFlyZoneInfoModal.swift
//  DRone
//
//  Created by Mihai Ocnaru on 23.08.2023.
//

import SwiftUI

struct NoFlyZoneInfoModal: View {
    var body: some View {
        VStack {
            Text("Legend")
                .foregroundColor(.white)
                .font(.abel(size: 32))
            
            
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach([
                        (Color.red, NoFlyZoneType.restricted.rawValue.capitalized, "Any kind of flight is strictly forbidden."),
                        (Color.orange, NoFlyZoneType.firstZone.rawValue.capitalized, "Only with the approvement from the landlord."),
                        (Color.yellow, NoFlyZoneType.requestZone.rawValue.capitalized, "In order to fly, you need an additional request from MAPN.")
                    ], id: \.2){ item in
                        
                        VStack(alignment: .leading, spacing: 24) {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(item.0)
                                    .frame(width: 20, height: 20)
                                
                                Text(item.1)
                                    .foregroundColor(.white)
                                    .font(.abel(size: 24))
                                
                            }
                            
                            HStack {
                                Text(item.2 )
                                    .foregroundColor(.white)
                                    .font(.abel(size: 20))
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            
                            if item.0 != Color.yellow {
                                Color.white
                                    .frame(height: 1)
                            }
                        }
                    
                    }
                }
                .padding(.vertical, 20)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("background.first").ignoresSafeArea())
    }
}

struct NoFlyZoneInfoModal_Previews: PreviewProvider {
    static var previews: some View {
        NoFlyZoneInfoModal()
            
    }
}
