//
//  ErrorView.swift
//  GenesisTask
//
//  Created by Artur Korol on 28.07.2025.
//

import SwiftUI

struct ErrorView: View {
    var error: String
    var action: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Failed to load options")
                .font(.headline)
                .foregroundColor(.red)
            Text(error)
                .font(.subheadline)
                .foregroundColor(.gray)
            Button("Retry") {
                action()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ErrorView(error: "", action: {})
}
