//
//  Main.swift
//  TextFields
//
//  Created by Ed Barnes on 05/05/2021.
//

import SwiftUI

struct Main: View {
    @EnvironmentObject var service: Service
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "arrow.uturn.left")
                        .foregroundColor(.white)
                    Text("Log out")
                }
                .modifier(CustomButton(color: .red))
                .padding(20)
                .onTapGesture {
                    self.service.logOut()
                }
                
                Spacer()
            }
            Spacer()
            Text("Main page")
            Spacer()
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
