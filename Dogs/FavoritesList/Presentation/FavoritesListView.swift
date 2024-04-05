//
//  FavoritesListView.swift
//  Dogs
//
//  Created by Youssef Ghattas on 24/03/2024.
//

import SwiftUI

struct FavoritesListView: View {
    @State var store: FavoritesListStore
    
    var body: some View {
        ScrollView {
            if store.state.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity)
                    .padding(.top, 48)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: UIScreen.main.bounds.width/2 - 4))], spacing: 8) {
                    ForEach(store.state.favoriteDogs.map { $0.toDogViewModel }) { dog in
                        DogView(
                            dog: dog,
                            isFavorite: store.isFavorite(dog: dog.toDogModel),
                            onTapDog: { store.send(.tapDog(dog.toDogModel)) },
                            onTapFavorite: { store.send(.tapFavorite(dog.toDogModel)) }
                        )
                    }
                }
                .navigationTitle("Favorites")
            }
        }
        .background(content: { Color.gray.opacity(0.2) })
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    FavoritesListView(
        store: FavoritesListStore(
            environment: FavoritesListEnvironment(
                repo: FavoritesRepoStub(),
                router: FavoritesRouterStub()
            )
        )
    )
}
