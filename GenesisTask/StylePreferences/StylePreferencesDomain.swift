//
//  StylePreferencesDomain.swift
//  GenesisTask
//
//  Created by Artur Korol on 27.07.2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct StylePreferencesDomain {
    @ObservableState
    struct State: Equatable {
        var options: [StyleOption] = StyleOption.mock
        var showAlert = false
        var isNextViewPresented = false
    }

    enum Action: Equatable {
        case selectOption(UUID)
        case continueTapped
        case alertDismissed
        case navigationDismissed
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .selectOption(id):
                for i in state.options.indices {
                    state.options[i].isSelected = (state.options[i].id == id)
                }
                return .none
            case .continueTapped:
                if state.options.contains(where: { $0.isSelected }) {
                    state.isNextViewPresented = true
                } else {
                    state.showAlert = true
                }
                return .none
            case .alertDismissed:
                state.showAlert = false
                return .none
            case .navigationDismissed:
                state.isNextViewPresented = false
                return .none

            }
        }
    }
}
