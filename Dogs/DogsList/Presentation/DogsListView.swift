//
//  DogsListView.swift
//  Dogs
//
//  Created by Youssef Ghattas on 24/03/2024.
//

import SwiftUI

struct DogsListView: View {
    @State var store: DogsStore
    
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
                            isFavorite: store.isFavorite(dog: dog),
                            onTapDog: { store.send(.tapDog(dog)) },
                            onTapFavorite: { store.send(.tapFavorites(dog)) }
                        )
                    }
                }
                .navigationTitle(store.state.breed.name.capitalized)
            }
        }
        .background(content: { Color.gray.opacity(0.2) })
    }
}

struct DogView: View {
    var dog: DogViewModel
    var isFavorite: Bool
    var onTapDog: () -> ()
    var onTapFavorite: () -> ()
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: dog.image)
                .resizable()
                .frame(width: UIScreen.main.bounds.width/2 - 4, height: 150)
                .scaledToFit()
                .onTapGesture {
                    onTapDog()
                }
            
            Image(systemName: favoriteImageName)
                .foregroundStyle(Color.red)
                .padding(4)
                .background(Circle().foregroundStyle(Color.white.opacity(0.5)))
                .padding(8)
                .onTapGesture {
                    onTapFavorite()
                }
        }
    }
    
    private var favoriteImageName: String {
        if isFavorite {
            "heart.fill"
        } else {
            "heart"
        }
    }
}

#Preview {
    DogsListView(store: DogsStore(breed: Breed(name: "Buhund")))
}
