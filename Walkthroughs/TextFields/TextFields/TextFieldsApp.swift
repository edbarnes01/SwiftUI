//
//  TextFieldsApp.swift
//  TextFields
//
//  Created by Ed Barnes on 05/05/2021.
//

import SwiftUI

@main
struct TextFieldsApp: App {
    var service = Service()
    var body: some Scene {
        WindowGroup {
            Container().environmentObject(service)
        }
    }
}
