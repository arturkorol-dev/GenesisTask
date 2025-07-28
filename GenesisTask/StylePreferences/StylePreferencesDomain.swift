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
        var options: [StyleOption] = []
        var isLoading = false
        var errorMessage: String?
        var showAlert = false
        var isNextViewPresented = false
    }

    enum Action: Equatable {
        case onAppear
        case fetchOptionsResponse(TaskResult<[StyleOption]>)
        case selectOption(UUID)
        case continueTapped
        case alertDismissed
        case navigationDismissed
    }

    @Dependency(\.quizClient) var quizClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    await send(
                        .fetchOptionsResponse(
                            TaskResult {
                                try await quizClient.fetchStyleOptions()
                            }
                        )
                    )
                }

            case let .fetchOptionsResponse(.success(options)):
                state.isLoading = false
                state.options = options
                return .none

            case let .fetchOptionsResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none

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
