//
//  GesturesApp.swift
//  Gestures
//
//  Created by Ed Barnes on 03/05/2021.
//

import SwiftUI

@main
struct GesturesApp: App {
    var service = Service()
    var body: some Scene {
        WindowGroup {
            Container().environmentObject(service)
        }
    }
}
