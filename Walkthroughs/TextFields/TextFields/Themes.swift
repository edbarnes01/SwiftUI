//
//  Themes.swift
//  TextFields
//
//  Created by Ed Barnes on 05/05/2021.
//

import Foundation
import SwiftUI

struct CustomTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .autocapitalization(.none)
            .foregroundColor(.black)
            .padding(10)
            .frame(width: UIScreen.main.bounds.width / 5 * 3)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .clipped()
            .shadow(color: .white, radius: 2)
    }
}

struct CustomButton: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(color == .white ? Color.black : .white )
            .padding(10)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .clipped()
    }
}

struct BackgroundGradient: ViewModifier {
    func body(content: Content) -> some View {
        content
        .background(
            LinearGradient(gradient: Gradient(colors: [.yellow, .purple, .yellow, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
            )
    }
}
