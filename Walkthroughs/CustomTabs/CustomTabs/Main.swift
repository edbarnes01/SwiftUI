//
//  Main.swift
//  CustomTabs
//
//  Created by Ed Barnes on 29/04/2021.
//

import SwiftUI

struct Main: View {
    @EnvironmentObject var service: Service
    var body: some View {
        VStack {
            switch self.service.currentPage {
                case .home:
                    Home()
                case .search:
                    Search()
                case .basket:
                    Basket()
                case .account:
                    Account()
            }
            Spacer()
            TabBar().environmentObject(service)
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
