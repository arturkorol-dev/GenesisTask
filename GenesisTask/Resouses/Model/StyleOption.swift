//
//  StyleOption.swift
//  GenesisTask
//
//  Created by Artur Korol on 27.07.2025.
//

import Foundation

struct StyleOption: Equatable, Identifiable {
    let id = UUID()
    var title: String
    var image: ImageResource
    var isSelected: Bool = false

    static let mock: [StyleOption] = [
        .init(title: "CASUAL", image: .casualStyle),
        .init(title: "BOHO", image: .bohoStyle),
        .init(title: "CLASSY", image: .classyStyle),
        .init(title: "LADYLIKE", image: .ladylikeStyle),
        .init(title: "URBAN", image: .urbanStyle),
        .init(title: "SPORTY", image: .sportyStyle)
    ]
}
