//
//  Container.swift
//  TextFields
//
//  Created by Ed Barnes on 05/05/2021.
//

import SwiftUI

struct Container: View {
    @EnvironmentObject var service: Service
    
    var body: some View {
        
        switch self.service.loggedIn {
        case true:
            Main().environmentObject(service)
        case false:
            Login().environmentObject(service)
        }
        
    }
}

struct Container_Previews: PreviewProvider {
    static var previews: some View {
        Container()
    }
}
