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
        case restoreSavedStyle
    }

    @Dependency(\.quizClient) var quizClient
    @Dependency(\.userDefaults) var userDefaults

    private let userDefaultsKey = "styleAnswer"

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
                    await send(.restoreSavedStyle)
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
                if let selected = state.options.first(where: { $0.isSelected }) {
                    saveSelectedStyle(selected.title)
                    state.isNextViewPresented = true
                } else {
                    state.showAlert = true
                }
                return .none
            case .restoreSavedStyle:
                restoreSelectedStyle(&state)
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

    // MARK: - Private Helpers

    private func saveSelectedStyle(_ title: String) {
        if let data = try? JSONEncoder().encode(title) {
            userDefaults.save(userDefaultsKey, data)
        }
    }

    private func restoreSelectedStyle(_ state: inout State) {
        guard let data = userDefaults.load(userDefaultsKey),
              let saved = try? JSONDecoder().decode(String.self, from: data) else { return }

        for i in state.options.indices {
            state.options[i].isSelected = (state.options[i].title == saved)
        }
    }
}
