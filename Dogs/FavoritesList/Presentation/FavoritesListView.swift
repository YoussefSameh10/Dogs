//
//  FavoritesListView.swift
//  Dogs
//
//  Created by Youssef Ghattas on 24/03/2024.
//

import SwiftUI

struct FavoritesListView: View {
    @State var store: FavoritesStore
    
    var body: some View {
        ScrollView {
            if store.state.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity)
                    .padding(.top, 48)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: UIScreen.main.bounds.width/2 - 4))], spacing: 8) {
                    ForEach(store.state.favoriteDogs) { dog in
                        DogView(
                            dog: dog,
                            isFavorite: store.isFavorite(dog: dog),
                            onTapDog: { store.send(.tapDog(dog)) },
                            onTapFavorite: { store.send(.tapFavorite(dog)) }
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
