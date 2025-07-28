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
        var options: [LifestyleAndInterestsQuestion] = []
        var isLoading = false
        var showAlert = false
        var errorMessage: String?
        var isNextViewPresented = false
    }

    enum Action: Equatable {
        case onAppear
        case fetchQuestionsResponse(TaskResult<[LifestyleAndInterestsQuestion]>)
        case toggleOption(UUID)
        case continueTapped
        case alertDismissed
        case navigationDismissed
        case restoreSavedAnswers
    }

    @Dependency(\.quizClient) var quizClient
    @Dependency(\.userDefaults) var userDefaults

    private let userDefaultsKey = "lifestyleAnswers"

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    await send(
                        .fetchQuestionsResponse(
                            TaskResult { try await quizClient.fetchLifestyleOptions() }
                        )
                    )
                    await send(.restoreSavedAnswers)
                }
            case let .fetchQuestionsResponse(.success(options)):
                state.isLoading = false
                state.options = options
                return .none
            case let .fetchQuestionsResponse(.failure(error)):
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
                    saveSelectedOptions(state.options)
                    state.isNextViewPresented = true
                } else {
                    state.showAlert = true
                }
                return .none
            case .restoreSavedAnswers:
                restoreSelectedOptions(&state)
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

    private func saveSelectedOptions(_ options: [LifestyleAndInterestsQuestion]) {
        let selected = options.filter { $0.isSelected }.map { $0.title }
        if let data = try? JSONEncoder().encode(selected) {
            userDefaults.save(userDefaultsKey, data)
        }
    }

    private func restoreSelectedOptions(_ state: inout State) {
        guard let data = userDefaults.load(userDefaultsKey),
              let saved = try? JSONDecoder().decode([String].self, from: data) else { return }

        for i in state.options.indices {
            state.options[i].isSelected = saved.contains(state.options[i].title)
        }
    }
}
