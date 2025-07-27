//
//  LifestyleAndInterestsDomain.swift
//  GenesisTask
//
//  Created by Artur Korol on 27.07.2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct LifestyleAndInterestsDomain {
    @ObservableState
    struct State: Equatable {
        var options: [LifestyleAndInterestsQuestion] = LifestyleAndInterestsQuestion.mock
        var showAlert = false
        var isNextViewPresented = false
    }

    enum Action: Equatable {
        case toggleOption(UUID)
        case continueTapped
        case alertDismissed
        case navigationDismissed
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .toggleOption(id):
                if let index = state.options.firstIndex(where: { $0.id == id }) {
                    state.options[index].isSelected.toggle()
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
