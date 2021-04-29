//
//  TabBar.swift
//  CustomTabs
//
//  Created by Ed Barnes on 29/04/2021.
//

import SwiftUI

struct TabInfo: Hashable {
    var name: String
    var page: Page
    var icon: String
}

let tabs = [
    TabInfo(name: "Home", page: .home, icon: "house"),
    TabInfo(name: "Search", page: .search, icon: "magnifyingglass"),
    TabInfo(name: "Basket", page: .basket, icon: "cart"),
    TabInfo(name: "Account", page: .account, icon: "person")
]

struct TabBar: View {
    @EnvironmentObject var service: Service
    let tabHeight: CGFloat = 50
    let tabWidth = UIScreen.main.bounds.width / CGFloat(tabs.count)
    let activeBarHeight: CGFloat =  2
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(tabs, id:\.self) { tab in
                TabButton(activeBarHeight: activeBarHeight,
                          isActive: self.service.currentPage == tab.page,
                          height: tabHeight,
                          width: tabWidth,
                          tabInfo: tab)
                    .environmentObject(service)
            }
        }
    }
}

struct TabButton: View {
    @EnvironmentObject var service: Service
    var activeBarHeight: CGFloat
    var isActive: Bool
    var height: CGFloat
    var width: CGFloat
    var tabInfo: TabInfo
    
    
    var body: some View {
        VStack {
            if isActive {
                Rectangle()
                    .frame(height: activeBarHeight)
                    .foregroundColor(.blue)
                    .shadow(color: .blue, radius: 4)
            }
            Spacer()
            Image(systemName: tabInfo.icon)
            Spacer()
        }
        .clipped()
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                self.service.changePage(tabInfo.page)
            }
        }
        .frame(width: width, height: isActive ? height + activeBarHeight : height)
    }
}


struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
