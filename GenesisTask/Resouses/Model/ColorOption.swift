//
//  ColorOption.swift
//  GenesisTask
//
//  Created by Artur Korol on 27.07.2025.
//

import Foundation

struct ColorOption: Equatable, Identifiable {
    let id = UUID()
    var title: String
    var colorHex: String
    var isSelected: Bool = false

    static let mock: [ColorOption] = [
        .init(title: "LIGHT BLUE", colorHex: "#ADD8E6"),
        .init(title: "BLUE", colorHex: "#0000FF"),
        .init(title: "INDIGO", colorHex: "#4B0082"),
        .init(title: "TURQUOISE", colorHex: "#40E0D0"),
        .init(title: "MINT", colorHex: "#98FF98"),
        .init(title: "OLIVE", colorHex: "#808000"),
        .init(title: "GREEN", colorHex: "#008000"),
        .init(title: "EMERALD", colorHex: "#50C878"),
        .init(title: "YELLOW", colorHex: "#FFFF00"),
        .init(title: "BEIGE", colorHex: "#F5F5DC"),
        .init(title: "ORANGE", colorHex: "#FFA500"),
        .init(title: "BROWN", colorHex: "#A52A2A"),
        .init(title: "PINK", colorHex: "#FFC0CB"),
        .init(title: "MAGENTA", colorHex: "#FF00FF"),
        .init(title: "RED", colorHex: "#FF0000"),
        .init(title: "PURPLE", colorHex: "#800080"),
        .init(title: "LIME", colorHex: "#00FF00"),
        .init(title: "CYAN", colorHex: "#00FFFF")
    ]
}
