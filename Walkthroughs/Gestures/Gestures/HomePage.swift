//
//  HomePage.swift
//  Gestures
//
//  Created by Ed Barnes on 03/05/2021.
//

import SwiftUI

struct HomePage: View {
    @EnvironmentObject var service: Service
    var pageNo: Int
    
    var body: some View {
        VStack {
            LazyVGrid(columns:[ GridItem(.adaptive(minimum: self.service.iconSize ))],
                      alignment: .center,
                      spacing: 20) {
                ForEach(self.service.pages[pageNo].icons, id: \.self) { icon in
                    IconView(icon: icon, showText: true).environmentObject(service)
                }
            }.padding(20)
            Spacer()
        }.background(Color.black.opacity(0.01))
    }
}

struct IconView: View {
    @EnvironmentObject var service: Service
    var icon: Icon
    var showText: Bool
    var body: some View {
        VStack{
            VStack{
                Image(systemName: icon.icon)
                    .foregroundColor(icon.foreground)
                    .font(.system(size: self.service.iconSize / 5 * 3))
            }
            .frame(width: self.service.iconSize, height: self.service.iconSize)
            .background(icon.background)
            .clipShape(RoundedRectangle(cornerRadius: self.service.iconSize / 5))
            if showText {
                Text(icon.name)
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .offset(x: 0, y: 2)
            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage(pageNo: 0).environmentObject(Service())
            .background(Color.black)
    }
}
