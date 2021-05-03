//
//  Container.swift
//  Gestures
//
//  Created by Ed Barnes on 03/05/2021.
//

import SwiftUI

struct Container: View {
    @EnvironmentObject var service: Service
    var body: some View {
        Main().environmentObject(service)
    }
}

struct Container_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }
}
