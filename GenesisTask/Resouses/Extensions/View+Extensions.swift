//
//  View+Extensions.swift
//  GenesisTask
//
//  Created by Artur Korol on 25.07.2025.
//

import SwiftUI

extension View {
    func hAlign(alignment: Alignment) -> some View {
      self
        .frame(maxWidth: .infinity, alignment: alignment)
    }

    func vAlign(alignment: Alignment) -> some View {
      self
        .frame(maxHeight: .infinity, alignment: alignment)
    }

    func frame(_ size: CGFloat) -> some View {
        self
          .frame(width: size, height: size)
    }
}
