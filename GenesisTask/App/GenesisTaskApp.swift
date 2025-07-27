//
//  GenesisTaskApp.swift
//  GenesisTask
//
//  Created by Artur Korol on 25.07.2025.
//

import SwiftUI

@main
struct GenesisTaskApp: App {
    var body: some Scene {
        WindowGroup {
            WelcomeView(
                store: .init(
                    initialState: .init(),
                    reducer: { WelcomeDomain() }
                )
            )
        }
    }
}
