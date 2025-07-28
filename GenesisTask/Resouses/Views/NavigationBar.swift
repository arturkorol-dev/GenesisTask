//
//  NavigationBar.swift
//  GenesisTask
//
//  Created by Artur Korol on 28.07.2025.
//

import SwiftUI

struct NavigationBar: View {
    var title: String
    var onBack: (() -> Void)?

    var body: some View {
        ZStack {
            if let onBack {
                Button {
                    onBack()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(.plain)
                .hAlign(alignment: .leading)
            }
            Text(title)
                .font(.kaiseiTokuminRegular(size: 14))
                .hAlign(alignment: .center)
        }
    }
}

#Preview {
    NavigationBar(title: "Colors") {}
}
