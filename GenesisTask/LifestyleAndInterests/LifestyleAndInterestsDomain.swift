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
    }

    @Dependency(\.quizClient) var quizClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    await send(
                        .fetchQuestionsResponse(
                            TaskResult {
                                try await quizClient.fetchLifestyleOptions()
                            }
                        )
                    )
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
