//
//  QuizClient.swift
//  GenesisTask
//
//  Created by Artur Korol on 28.07.2025.
//

import ComposableArchitecture

struct QuizClient {
    var fetchLifestyleOptions: @Sendable () async throws -> [LifestyleAndInterestsQuestion]
    var fetchStyleOptions: @Sendable () async throws -> [StyleOption]
    var fetchColorOptions: @Sendable () async throws -> [ColorOption]
}

extension DependencyValues {
    var quizClient: QuizClient {
        get { self[QuizClientKey.self] }
        set { self[QuizClientKey.self] = newValue }
    }
}

private enum QuizClientKey: DependencyKey {
    static let liveValue = QuizClient.live
    static let previewValue = QuizClient.mock
}

extension QuizClient {
    static let live = QuizClient(
        fetchLifestyleOptions: {
            try await QuizService().fetchLifestyleOptions()
        },
        fetchStyleOptions: {
            try await QuizService().fetchStyleOptions()
        },
        fetchColorOptions: {
            try await QuizService().fetchColorOptions()
        }
    )

    static let mock = QuizClient(
        fetchLifestyleOptions: { LifestyleAndInterestsQuestion.mock },
        fetchStyleOptions: { StyleOption.mock },
        fetchColorOptions: { ColorOption.mock }
    )
}
