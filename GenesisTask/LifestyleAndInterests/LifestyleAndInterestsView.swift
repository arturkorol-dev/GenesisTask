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
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Group {
                if viewStore.isLoading {
                    LoadingView()
                } else if let error = viewStore.errorMessage {
                    ErrorView(error: error) {
                        viewStore.send(.onAppear)
                    }
                } else {
                    VStack(spacing: 24) {
                        NavigationBar(title: "LIFESTYLE & INTERESTS")
                        title
                        questions(viewStore: viewStore)
                        continueButton(viewStore: viewStore)
                    }
                    .padding()
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .alert(
                "Please select at least one option.",
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
                    send: LifestyleAndInterestsDomain.Action.navigationDismissed
                )
            ) {
                WithPerceptionTracking {
                    StylePreferencesView(
                        store: .init(
                            initialState: .init(),
                            reducer: { StylePreferencesDomain() }
                        )
                    )
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
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
                .font(.kaiseiTokuminMedium(size: 26))

            Text("We offer services via live-chat mode.")
                .font(.poppinsLight(size: 13))
                .foregroundColor(.secondary)
        }
    }

    func questions(
        viewStore: ViewStore<LifestyleAndInterestsDomain.State, LifestyleAndInterestsDomain.Action>
    ) -> some View {
        ScrollView {
            WithPerceptionTracking {
                LazyVStack(spacing: 12) {
                    ForEach(viewStore.options) { option in
                        Button {
                            viewStore.send(.toggleOption(option.id))
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(option.title)
                                        .font(.poppinsMedium(size: 13))
                                        .foregroundColor(.black)
                                    Text(option.subtitle)
                                        .font(.poppinsLight(size: 14))
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
