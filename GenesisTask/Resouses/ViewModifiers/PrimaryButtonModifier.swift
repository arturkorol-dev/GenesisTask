//
//  PrimaryButtonModifier.swift
//  GenesisTask
//
//  Created by Artur Korol on 27.07.2025.
//

import SwiftUI

struct PrimaryButtonModifier: ViewModifier {
    var style: ColorScheme
    private var isLight: Bool { style == .light }

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .background(isLight ? Color.white : Color.black)
            .foregroundColor(isLight ? Color.black : Color.white)
            .fontWeight(.semibold)
            .shadow(color: Color.white, radius: 20, x: 0, y: -30)
    }
}
