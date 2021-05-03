//
//  Models.swift
//  Gestures
//
//  Created by Ed Barnes on 03/05/2021.
//

import Foundation
import SwiftUI

struct Icon: Hashable {
    var name: String
    var icon: String
    var foreground: Color
    var background: Color
}

struct PageData: Hashable {
    var pageNo: Int
    var icons: [Icon]
}

let examplePages = [examplePageZero, examplePageOne, examplePageTwo]

let examplePageZero = PageData(pageNo: 0, icons: [
    Icon(name: "Safari", icon: "safari.fill", foreground: .blue, background: .white),
    Icon(name: "Facetime", icon: "video.fill", foreground: .white, background: .green),
    Icon(name: "Calendar", icon: "calendar", foreground: .red, background: .white),
    Icon(name: "Mail", icon: "envelope.fill", foreground: .white, background: .blue),
    Icon(name: "Notes", icon: "note.text", foreground: .white, background: .yellow),
])

let examplePageOne = PageData(pageNo: 1, icons: [
    Icon(name: "Maps", icon: "map.fill", foreground: .white, background: .purple),
    Icon(name: "Phone", icon: "phone.fill", foreground: .white, background: .green),
    Icon(name: "Calculator", icon: "plus.slash.minus", foreground: .black, background: .gray),
    Icon(name: "Health", icon: "heart.fill", foreground: .red, background: .white),
    Icon(name: "Camera", icon: "camera.fill", foreground: .black, background: .gray),
    Icon(name: "App Store", icon: "cart", foreground: .white, background: .blue),
])

let examplePageTwo = PageData(pageNo: 2, icons: [
    Icon(name: "Twitter", icon: "leaf", foreground: .white, background: .blue),
    Icon(name: "Facebook", icon: "function", foreground: .white, background: .blue)
])

let exampleBottomBar = PageData(pageNo: 3, icons: [
    Icon(name: "Contacts", icon: "person.fill", foreground: .darkGray, background: .gray),
    Icon(name: "Weather", icon: "cloud.fill", foreground: .white, background: .blue),
    Icon(name: "Messages", icon: "message.fill", foreground: .white, background: .green),
    Icon(name: "Spotify", icon: "wave.3.backward.circle.fill", foreground: .green, background: .black)
    
])
