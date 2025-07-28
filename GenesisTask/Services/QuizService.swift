//
//  QuizService.swift
//  GenesisTask
//
//  Created by Artur Korol on 28.07.2025.
//

import Foundation
import FirebaseFirestore

final class QuizService {
    private let db = Firestore.firestore()

    func fetchLifestyleOptions() async throws -> [LifestyleAndInterestsQuestion] {
        let doc = try await db.collection("quizQuestions").document("lifestyle").getDocument()
        let question = try doc.data(as: LifestyleAndInterestsQuestions.self)
        return question.options
    }

    func fetchStyleOptions() async throws -> [StyleOption] {
        let doc = try await db.collection("quizQuestions").document("style").getDocument()
        let styleData = try doc.data(as: StyleOptionQuestions.self)
        return styleData.options
    }

    func fetchColorOptions() async throws -> [ColorOption] {
        let doc = try await db.collection("quizQuestions").document("colors").getDocument()
        if !doc.exists {
            throw NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document lifestyle not found"])
        }
        debugPrint(doc.data() ?? [:])
        let colorData = try doc.data(as: ColorQuestions.self)
        return colorData.options
    }
}
