//
//  WelcomeView.swift
//  GenesisTask
//
//  Created by Artur Korol on 25.07.2025.
//

import SwiftUI
import ComposableArchitecture

struct WelcomeView: View {
    let store: StoreOf<WelcomeDomain>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                ZStack {
                    background
                    VStack(spacing: 61) {
                        Spacer()
                        title
                        takeAQuizButton(viewStore: viewStore)
                    }
                    .padding()
                }
                .navigationDestination(
                    isPresented: viewStore.binding(
                        get: \.isQuizActive,
                        send: WelcomeDomain.Action.setQuizActive
                    )
                ) {
                    LifestyleAndInterestsView(
                        store: .init(
                            initialState: .init(),
                            reducer: { LifestyleAndInterestsDomain() }
                        )
                    )
                }
            }
        }
    }
}

#Preview {
    WelcomeView(
        store: Store(
            initialState: WelcomeDomain.State(),
            reducer: { WelcomeDomain() }
        )
    )
}

private extension WelcomeView {
    @ViewBuilder
    var background: some View {
        Image(.welcomeView)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()

        LinearGradient(
            gradient: Gradient(
                colors: [.black, .black.opacity(0.9), .clear]
            ),
            startPoint: .bottom,
            endPoint: .center
        )
        .ignoresSafeArea()
    }

    var title: some View {
        VStack(alignment: .leading) {
            Text("Online Personal \nStyling.")
            Text("Outfits for \nEvery Woman.")
        }
        .font(.kaiseiTokuminMedium(size: 32))
        .foregroundColor(.white)
        .hAlign(alignment: .leading)
    }

    func takeAQuizButton(
        viewStore: ViewStore<WelcomeDomain.State, WelcomeDomain.Action>
    ) -> some View {
        Button {
            viewStore.send(.takeQuizButtonTapped)
        } label: {
            Text("TAKE A QUIZ")
                .modifier(PrimaryButtonModifier(style: .light))
        }
        .padding(.bottom, 60)
    }
}
