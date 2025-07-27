//
//  CheckmarkView.swift
//  GenesisTask
//
//  Created by Artur Korol on 27.07.2025.
//

import SwiftUI

struct CheckmarkView: View {
    var isSelected: Bool

    var body: some View {
        Image(systemName: isSelected ? "checkmark.square.fill" : "square")
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(isSelected ? .black : .gray)
            .padding(8)
    }
}

#Preview {
    CheckmarkView(isSelected: true)
}
