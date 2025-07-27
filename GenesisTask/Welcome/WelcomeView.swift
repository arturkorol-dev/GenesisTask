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

                    VStack(spacing: 61) {
                        Spacer()

                        VStack(alignment: .leading) {
                            Text("Online Personal \nStyling.")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)

                            Text("Outfits for \nEvery Woman.")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .hAlign(alignment: .leading)
                        .padding(.horizontal, 20)

                        Button(action: {
                            viewStore.send(.takeQuizButtonTapped)
                        }) {
                            Text("TAKE A QUIZ")
                                .fontWeight(.regular)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 60)

                    }
                }
                .navigationDestination(
                    isPresented: viewStore.binding(
                        get: \.isQuizActive,
                        send: WelcomeDomain.Action.setQuizActive
                    )
                ) {
                    Text("Quiz")
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
