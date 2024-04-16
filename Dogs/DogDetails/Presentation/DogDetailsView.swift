//
//  DogDetailsView.swift
//  Dogs
//
//  Created by Youssef Ghattas on 29/03/2024.
//

import SwiftUI

struct DogDetailsView: View {
    @State var store: DogDetailsStore
    @GestureState var scale = 1.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Image(uiImage: dog.image)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(scale)
                    .gesture(magnifyGesture)
                
                HStack(spacing: 16) {
                    Button {
                        store.send(.tapFavorite)
                    } label: {
                        Image(systemName: favoriteImageName)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(favoriteImageColor)
                            .padding(8)                        
                    }
                    
                    Button {
                        store.send(.tapShare)
                    } label: {
                        Image(systemName: "arrow.down")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(8)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                Spacer()
            }
        }
        .tint(Color.black)
        .navigationTitle(dog.breed.name.capitalized)
        .sheet(isPresented: $store.state.isSharing) {
            ShareSheet(activityItems: [store.state.dog.toDogViewModel.image])
        }
    }
    
    private var magnifyGesture: some Gesture {
        MagnifyGesture().updating($scale) { value, gestureState, _ in
            gestureState = value.magnification
        }
    }
    
    @MainActor
    private var dog: DogViewModel {
        store.state.dog.toDogViewModel
    }
    
    @MainActor
    private var favoriteImageName: String {
        if dog.isFavorite {
            "heart.fill"
        } else {
            "heart"
        }
    }
    
    @MainActor
    private var favoriteImageColor: Color {
        if dog.isFavorite {
            Color.red
        } else {
            Color.black
        }
    }
}

#Preview {
    let repo = FavoritesRepoStub()
    let dog = repo.favoriteDogs.first!.toDogViewModel
    return DogDetailsView(
        store: DogDetailsStore(
            dog: dog,
            environment: DogDetailsEnvironment(repo: repo)
        )
    )
}
