//
//  Main.swift
//  Gestures
//
//  Created by Ed Barnes on 03/05/2021.
//

import SwiftUI

struct Main: View {
    @EnvironmentObject var service: Service
    @State var liveDrag: CGFloat = 0
    
    var body: some View {
        
        let HomeSwipeGesture = DragGesture()
            .onChanged { change in
                self.liveDrag = change.translation.width
            }
            .onEnded { change in
                if change.translation.width < 0 && self.service.activePage < self.service.pages.count - 1 {
                    withAnimation(.easeOut(duration: 0.2)) {
                        self.service.changePage(self.service.activePage + 1)
                        self.liveDrag = 0
                    }
                    
                }
                if change.translation.width > 0 && self.service.activePage > 0 {
                    withAnimation(.easeOut(duration: 0.2)) {
                        self.service.changePage(self.service.activePage - 1)
                        self.liveDrag = 0
                    }
                }
                withAnimation(.easeOut(duration: 0.4)) {
                    self.liveDrag = 0
                }
            }
        
        
        VStack(spacing: 0){
            ZStack {
                ForEach(self.service.pages, id: \.self) { page in
                    HomePage(pageNo: page.pageNo).environmentObject(service)
                        .offset(x: CGFloat(page.pageNo) * UIScreen.main.bounds.width, y: 0)
                        .gesture(HomeSwipeGesture)
                }
            }
            
            .frame(width: UIScreen.main.bounds.width)
            .offset(x: -CGFloat(self.service.activePage) * UIScreen.main.bounds.width, y: 0)
            .offset(x: self.liveDrag, y: 0)
            
            PageScroll().environmentObject(service)
            BottomBar().environmentObject(service)
        }.background(
            Image("example_background")
                .resizable()
                .ignoresSafeArea()
                //.scaledToFill()
        )
    }
}

struct PageScroll: View {
    @EnvironmentObject var service: Service
    @State var isScrolling = true
    var body: some View {
        
        let ScrollPressGesture = LongPressGesture(minimumDuration: 0.4)
            .onChanged { _ in
                self.isScrolling = true
            }
        
        HStack{
            HStack {
                ForEach(self.service.pages, id:\.self) { page in
                    Image(systemName: "circlebadge.fill")
                        .foregroundColor(self.service.isActivePage(pageNo: page.pageNo) ? .white : .gray)
                        .onTapGesture {
                            self.service.changePage(page.pageNo)
                        }
                        .font(.custom("", size: 10))
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.darkGray)
                    .opacity(isScrolling ? 0 : 0.8)
            )
            
        }.padding(10)
        .gesture(ScrollPressGesture)
    }
}

struct BottomBar: View {
    @EnvironmentObject var service: Service
    var body: some View {
        HStack(spacing: 20) {
            ForEach(self.service.bottomBar.icons, id:\.self) { icon in
                IconView(icon: icon, showText: false)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: self.service.iconSize * 5 / 3)
        .background(Color.darkGray)
        .opacity(0.9)
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main().environmentObject(Service())
    }
}
