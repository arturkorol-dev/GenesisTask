//
//  LoadingView.swift
//  GenesisTask
//
//  Created by Artur Korol on 28.07.2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView("Loading...")
                .font(.headline)
            Spacer()
        }
    }
}

#Preview {
    LoadingView()
}
