//
//  FavouriteColorsDomain.swift
//  GenesisTask
//
//  Created by Artur Korol on 27.07.2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct FavouriteColorsDomain {
    @ObservableState
    struct State: Equatable {
        var options: [ColorOption] = []
        var isLoading = false
        var errorMessage: String?
        var showAlert = false
        var isNextViewPresented = false
    }

    enum Action: Equatable {
        case onAppear
        case fetchColorsResponse(TaskResult<[ColorOption]>)
        case toggleOption(UUID)
        case continueTapped
        case alertDismissed
        case restoreSavedColors
    }

    @Dependency(\.quizClient) var quizClient
    @Dependency(\.userDefaults) var userDefaults

    private let userDefaultsKey = "colorAnswers"

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    await send(
                        .fetchColorsResponse(
                            TaskResult { try await quizClient.fetchColorOptions() }
                        )
                    )
                    await send(.restoreSavedColors)
                }
            case let .fetchColorsResponse(.success(options)):
                state.isLoading = false
                state.options = options
                return .none
            case let .fetchColorsResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
            case let .toggleOption(id):
                if let index = state.options.firstIndex(where: { $0.id == id }) {
                    state.options[index].isSelected.toggle()
                }
                return .none
            case .continueTapped:
                if state.options.contains(where: { $0.isSelected }) {
                    saveSelectedColors(state.options)
                    state.isNextViewPresented = true
                } else {
                    state.showAlert = true
                }
                return .none
            case .restoreSavedColors:
                restoreSelectedColors(&state)
                return .none
            case .alertDismissed:
                state.showAlert = false
                return .none
            }
        }
    }

    // MARK: - Private Helpers

    private func saveSelectedColors(_ options: [ColorOption]) {
        let selected = options.filter { $0.isSelected }.map { $0.colorHex }
        if let data = try? JSONEncoder().encode(selected) {
            userDefaults.save(userDefaultsKey, data)
        }
    }

    private func restoreSelectedColors(_ state: inout State) {
        guard let data = userDefaults.load(userDefaultsKey),
              let saved = try? JSONDecoder().decode([String].self, from: data) else { return }

        for i in state.options.indices {
            state.options[i].isSelected = saved.contains(state.options[i].colorHex)
        }
    }
}
