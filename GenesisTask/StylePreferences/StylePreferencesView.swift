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
    @Environment(\.dismiss) private var dismiss

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 16),
        count: 2
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
                    VStack(alignment: .leading, spacing: 20) {
                        NavigationBar(title: "Style preferences") {
                            dismiss()
                        }
                        title
                        options(viewStore: viewStore)
                        continueButton(viewStore: viewStore)
                    }
                    .padding()
                }
            }
            .toolbar(.hidden, for: .navigationBar)
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
                WithPerceptionTracking {
                    FavouriteColorsView(store: .init(initialState: .init(), reducer: {
                        FavouriteColorsDomain()
                    }))
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
            .font(.kaiseiTokuminMedium(size: 26))
            .multilineTextAlignment(.leading)
    }
    
    func options(
        viewStore: ViewStoreOf<StylePreferencesDomain>
    ) -> some View {
        ScrollView {
            WithPerceptionTracking {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewStore.options) { option in
                        Button {
                            viewStore.send(.selectOption(option.id))
                        } label: {
                            VStack(spacing: 4) {
                                if let imageUrl = option.imageUrl {
                                    AsyncImage(url: imageUrl) { image in
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(width: 108, height: 122)
                                            .clipped()
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 108, height: 122)
                                    }
                                } else if let image = option.imageName {
                                    Image(image)
                                        .scaledToFill()
                                        .frame(width: 108, height: 122)
                                } else {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 108, height: 122)
                                        .overlay(Text("No image").font(.caption))
                                }
                                
                                Text(option.title)
                                    .font(.poppinsLight(size:13))
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
