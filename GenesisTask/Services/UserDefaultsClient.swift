//
//  UserDefaultsClient.swift
//  GenesisTask
//
//  Created by Artur Korol on 28.07.2025.
//

import Foundation
import ComposableArchitecture

struct UserDefaultsClient {
    var save: @Sendable (String, Data) -> Void
    var load: @Sendable (String) -> Data?
    var remove: @Sendable (String) -> Void
}

extension DependencyValues {
    var userDefaults: UserDefaultsClient {
        get { self[UserDefaultsClientKey.self] }
        set { self[UserDefaultsClientKey.self] = newValue }
    }
}

private enum UserDefaultsClientKey: DependencyKey {
    static let liveValue = UserDefaultsClient(
        save: { key, data in UserDefaults.standard.set(data, forKey: key) },
        load: { key in UserDefaults.standard.data(forKey: key) },
        remove: { key in UserDefaults.standard.removeObject(forKey: key) }
    )
}
