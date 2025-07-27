//
//  StylePreferencesView.swift
//  GenesisTask
//
//  Created by Artur Korol on 27.07.2025.
//

import SwiftUI
import ComposableArchitecture

struct StylePreferencesView: View {
    let store: StoreOf<StylePreferencesDomain>

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 16),
        count: 2
    )

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 20) {
                title
                options(viewStore: viewStore)
                continueButton(viewStore: viewStore)
            }
            .navigationTitle("Style preferences")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            .alert(
                "Please select one option.",
                isPresented: viewStore.binding(
                    get: \.showAlert,
                    send: .alertDismissed
                )
            ) {
                Button("OK", role: .cancel) {}
            }
            .navigationDestination(
                isPresented: viewStore.binding(
                    get: \.isNextViewPresented,
                    send: StylePreferencesDomain.Action.navigationDismissed
                )
            ) {
                FavouriteColorsView(store: .init(initialState: .init(), reducer: {
                    FavouriteColorsDomain()
                }))
            }
        }
    }
}

#Preview {
    NavigationStack {
        StylePreferencesView(
            store: Store(
                initialState: StylePreferencesDomain.State(),
                reducer: { StylePreferencesDomain() }
            )
        )
    }
}

private extension StylePreferencesView {
    var title: some View {
        Text("Which style best represents you?")
            .font(.title)
            .fontWeight(.medium)
            .multilineTextAlignment(.leading)
    }

    func options(
        viewStore: ViewStoreOf<StylePreferencesDomain>
    ) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewStore.options) { option in
                    Button {
                        viewStore.send(.selectOption(option.id))
                    } label: {
                        VStack(spacing: 4) {
                            Image(option.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 108, height: 122)

                            Text(option.title)
                                .font(.body)
                                .foregroundColor(.black)
                        }
                        .hAlign(alignment: .center)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(
                                    option.isSelected ? Color.black : Color.gray.opacity(0.3),
                                    lineWidth: 1
                                )
                                .padding(1)
                        )
                        .overlay(
                            CheckmarkView(isSelected: option.isSelected),
                            alignment: .topTrailing
                        )
                    }
                }
            }
        }
    }

    func continueButton(
        viewStore: ViewStoreOf<StylePreferencesDomain>
    ) -> some View {
        Button {
            viewStore.send(.continueTapped)
        } label: {
            Text("CONTINUE")
                .modifier(PrimaryButtonModifier(style: .dark))
        }
    }
}
