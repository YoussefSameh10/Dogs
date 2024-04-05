//
//  DogsListView.swift
//  Dogs
//
//  Created by Youssef Ghattas on 24/03/2024.
//

import SwiftUI

struct DogsListView: View {
    @State var store: DogsListStore
    
    var body: some View {
        ScrollView {
            if store.state.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity)
                    .padding(.top, 48)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: UIScreen.main.bounds.width/2 - 4))], spacing: 8) {
                    ForEach(store.state.dogs) { dog in
                        DogView(
                            dog: dog,
                            isFavorite: store.state.isFavorite(dog: dog),
                            onTapDog: {
                                store.send(.tapDog(dog))
                            },
                            onTapFavorite: { store.send(.tapFavorites(dog)) }
                        )
                    }
                }
                .navigationTitle(store.state.breed.name.capitalized)
            }
        }
        .background(content: { Color.gray.opacity(0.2) })
        .task {
            store.send(.onAppear)
        }
        .onDisappear {
            store.send(.onDisappear)
        }
    }
}

#Preview {
    DogsListView(
        store: DogsListStore(
            breed: BreedModel(name: "Husky"),
            environment: DogsListEnvironment(
                repo: DogsRepoStub(),
                router: DogsRouterStub()
            )
        )
    )
}
