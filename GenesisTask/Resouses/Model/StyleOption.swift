//
//  StyleOption.swift
//  GenesisTask
//
//  Created by Artur Korol on 27.07.2025.
//

import Foundation

struct StyleOption: Decodable, Equatable, Identifiable {
    var id = UUID()
    var title: String
    var imageUrl: URL?
    var imageName: String?
    var isSelected: Bool = false

    private enum CodingKeys: String, CodingKey {
        case title
        case imageUrl
    }
}

extension StyleOption {
    static let mock: [StyleOption] = [
        .init(title: "CASUAL", imageName: "casual_style"),
        .init(title: "BOHO", imageName: "boho_style"),
        .init(title: "CLASSY", imageName: "classy_style"),
        .init(title: "LADYLIKE", imageName: "ladylike_style"),
        .init(title: "URBAN", imageName: "urban_style"),
        .init(title: "SPORTY", imageName: "sporty_style")
    ]
}


struct StyleOptionQuestions: Decodable {
    var options: [StyleOption]
}
