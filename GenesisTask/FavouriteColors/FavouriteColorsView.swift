//
//  FavouriteColorsView.swift
//  GenesisTask
//
//  Created by Artur Korol on 27.07.2025.
//

import SwiftUI
import ComposableArchitecture

struct FavouriteColorsView: View {
    let store: StoreOf<FavouriteColorsDomain>

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 16),
        count: 3
    )

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
                    VStack(alignment: .leading, spacing: 16) {
                        title
                        colors(viewStore: viewStore)
                        continueButton(viewStore: viewStore)
                    }
                    .padding()
                }
            }
            .navigationTitle("Style preferences")
            .navigationBarTitleDisplayMode(.inline)
            .alert(
                "Please select at least one color.",
                isPresented: viewStore.binding(
                    get: \.showAlert,
                    send: .alertDismissed
                )
            ) {
                Button("OK", role: .cancel) {}
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

#Preview {
    NavigationStack {
        FavouriteColorsView(
            store: Store(
                initialState: FavouriteColorsDomain.State(),
                reducer: { FavouriteColorsDomain() }
            )
        )
    }
}

private extension FavouriteColorsView {
    var title: some View {
        Text("Choose favourite colors")
            .font(.title)
            .fontWeight(.medium)
            .multilineTextAlignment(.leading)
    }

    func colors(
        viewStore: ViewStoreOf<FavouriteColorsDomain>
    ) -> some View {
        ScrollView {
            WithPerceptionTracking {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewStore.options) { option in
                        Button {
                            viewStore.send(.toggleOption(option.id))
                        } label: {
                            VStack(spacing: 8) {
                                Rectangle()
                                    .fill(Color(hex: option.colorHex))
                                    .frame(width: 32, height: 32)

                                Text(option.title)
                                    .font(.footnote)
                                    .foregroundColor(.black)
                            }
                            .hAlign(alignment: .center)
                            .padding(.vertical, 22)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
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
    }

    func continueButton(
        viewStore: ViewStoreOf<FavouriteColorsDomain>
    ) -> some View {
        Button {
            viewStore.send(.continueTapped)
        } label: {
            Text("CONTINUE")
                .modifier(PrimaryButtonModifier(style: .dark))
        }
    }
}
