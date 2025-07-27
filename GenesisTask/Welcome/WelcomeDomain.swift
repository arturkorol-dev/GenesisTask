//
//  WelcomeDomain.swift
//  GenesisTask
//
//  Created by Artur Korol on 25.07.2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WelcomeDomain {
    @ObservableState
    struct State: Equatable {
        var isQuizActive = false
    }

    enum Action: Equatable {
        case takeQuizButtonTapped
        case setQuizActive(Bool)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .takeQuizButtonTapped:
                state.isQuizActive = true
                return .none

            case .setQuizActive(let active):
                state.isQuizActive = active
                return .none
            }
        }
    }
}

