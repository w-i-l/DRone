//
//  TabBar.swift
//  DRone
//
//  Created by Mihai Ocnaru on 07.08.2023.
//

import SwiftUI

struct TabBar: View {
    
    @StateObject private var viewModel: TabBarViewModel = TabBarViewModel()
    
    var tabBarItems: [(AppNavigationTabs, String)] {
        
        if viewModel.guestMode {
            return [
                (AppNavigationTabs.home, "house"),
                (AppNavigationTabs.map, "map"),
                (AppNavigationTabs.settings, "gear")
            ]
        } else {
            return [
                (AppNavigationTabs.home, "house"),
                (AppNavigationTabs.request, "paperplane"),
                (AppNavigationTabs.map, "map"),
                (AppNavigationTabs.settings, "gear")
            ]
        }
    }
    
    var body: some View {
        
        VStack {
            if viewModel.isTabBarVisible {
                ZStack {
                
                Color.white
                    .cornerRadius(12, corners: [.topLeft, .topRight])
                    .offset(y: -2)
                
                Color("background.second")
                    .cornerRadius(12, corners: [.topLeft, .topRight])

                HStack {
                    ForEach(tabBarItems, id: \.1) { item in
                        
                        Spacer()
                        
                        Button(action: {
                            AppService.shared.selectedTab.value = item.0
                        }, label: {
                            VStack {
                                Image(systemName: item.1)
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 24)
                                    .foregroundColor(viewModel.selectedTab == item.0 ? Color("accent.blue") : .white)
                                    .scaledToFit()
                                    .padding(.bottom, 20)
//
//                                Circle()
//                                    .fill(viewModel.selectedTab == item.0 ? Color("accent.blue") : .clear)
//                                    .frame(width: 10, height: 10)
                                
                            }
                            .frame(height: 50)
                        })
                        .padding(.top, 10)
                        
                        Spacer()
                }}
            }
                .frame(height: UIScreen.main.bounds.height / 11.3)
            } else {
                /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
            }
        }
        
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Spacer()
            TabBar()
                .padding(.bottom, 20)
        }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(LinearGradient(colors: [Color("background.first"), Color("background.second")], startPoint: .top, endPoint: .bottom))
    }
}
