//
//  CustomTabsApp.swift
//  CustomTabs
//
//  Created by Ed Barnes on 22/04/2021.
//

import SwiftUI

@main
struct CustomTabsApp: App {
    var service = Service()
    var body: some Scene {
        WindowGroup {
            Container().environmentObject(service)
        }
    }
}
