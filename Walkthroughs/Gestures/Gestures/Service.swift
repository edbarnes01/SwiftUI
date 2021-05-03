//
//  Service.swift
//  Gestures
//
//  Created by Ed Barnes on 03/05/2021.
//

import Foundation
import SwiftUI

class Service: ObservableObject {
    @Published var pages = examplePages
    @Published var bottomBar = exampleBottomBar
    @Published private(set) var activePage: Int = 0
    @Published var iconSize: CGFloat = UIScreen.main.bounds.width / 6
    
    func isActivePage(pageNo: Int) -> Bool {
        return activePage == pageNo
    }
    
    func changePage(_ pageNumber: Int) {
        self.activePage = pageNumber
    }
}
