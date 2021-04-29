//
//  Service.swift
//  CustomTabs
//
//  Created by Ed Barnes on 29/04/2021.
//

import Foundation

enum Page {
    case home
    case search
    case basket
    case account
}

class Service: ObservableObject {
    @Published var currentPage: Page = .home
    
    func changePage(_ page: Page) {
        self.currentPage = page
    }
}
