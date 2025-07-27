//
//  LifestyleAndInterestsView.swift
//  GenesisTask
//
//  Created by Artur Korol on 27.07.2025.
//

import SwiftUI
import ComposableArchitecture

struct LifestyleAndInterestsView: View {
    let store: StoreOf<LifestyleAndInterestsDomain>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 24) {
                title
                questions(viewStore: viewStore)
                continueButton(viewStore: viewStore)
            }
            .navigationTitle("LIFESTYLE & INTERESTS")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .alert(
                "Please select at least one option.",
                isPresented: viewStore.binding(
                    get: \.showAlert,
                    send: .alertDismissed
                )
            ) {
                Button("OK", role: .cancel) {}
            }
            .padding()
            .navigationDestination(
                isPresented: viewStore.binding(
                    get: \.isNextViewPresented,
                    send: LifestyleAndInterestsDomain.Action.navigationDismissed
                )
            ) {
                Text("Next")
            }
        }
    }
}

#Preview {
    NavigationStack {
        LifestyleAndInterestsView(
            store: Store(
                initialState: LifestyleAndInterestsDomain.State(),
                reducer: { LifestyleAndInterestsDomain() }
            )
        )
    }
}

private extension LifestyleAndInterestsView {
    var title: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("What’d you like our stylists to focus on?")
                .font(.title)
                .fontWeight(.medium)

            Text("We offer services via live-chat mode.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    func questions(
        viewStore: ViewStore<LifestyleAndInterestsDomain.State, LifestyleAndInterestsDomain.Action>
    ) -> some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewStore.options) { option in
                    Button {
                        viewStore.send(.toggleOption(option.id))
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(option.title)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text(option.subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: option.isSelected ? "checkmark.square.fill" : "square")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(option.isSelected ? .black : .gray)
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    }
                }
            }
        }
    }

    func continueButton(
        viewStore: ViewStore<LifestyleAndInterestsDomain.State, LifestyleAndInterestsDomain.Action>
    ) -> some View {
        Button {
            viewStore.send(.continueTapped)
        } label: {
            Text("CONTINUE")
                .modifier(PrimaryButtonModifier(style: .dark))
        }
    }
}
