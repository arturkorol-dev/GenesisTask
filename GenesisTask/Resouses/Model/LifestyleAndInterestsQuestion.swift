//
//  LifestyleAndInterestsQuestion.swift
//  GenesisTask
//
//  Created by Artur Korol on 27.07.2025.
//

import Foundation

struct LifestyleAndInterestsQuestion: Equatable, Identifiable {
    let id = UUID()
    var title: String
    var subtitle: String
    var isSelected: Bool = false
}

extension LifestyleAndInterestsQuestion {
    static let mock: [Self] = [
        .init(title: "REINVENT WARDROBE", subtitle: "to discover fresh outfit ideas"),
        .init(title: "DEFINE COLOR PALETTE", subtitle: "to enhance my natural features"),
        .init(title: "CREATE A SEASONAL CAPSULE", subtitle: "to curate effortless and elegant looks"),
        .init(title: "DEFINE MY STYLE", subtitle: "to discover my signature look"),
        .init(title: "CREATE AN OUTFIT FOR AN EVENT", subtitle: "to own a spotlight wherever you go")
    ]
}
