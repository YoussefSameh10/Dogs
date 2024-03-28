//
//  DogsListView.swift
//  Dogs
//
//  Created by Youssef Ghattas on 24/03/2024.
//

import SwiftUI

struct DogViewModel: Identifiable, Equatable {
    let image: UIImage
    let id: String
    
    init(id: String, image: UIImage) {
        self.image = image
        self.id = id
    }
}

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
                            onTapImage: {  },
                            onTapFavorite: { store.send(.addToFavorites(dog)) }
                        )
                    }
                }
            }
        }
        .background(content: { Color.gray.opacity(0.2) })
        .onAppear {
            store.send(.onAppear)
        }
    }
}

struct DogView: View {
    var dog: DogViewModel
    var isFavorite: Bool
    var onTapImage: () -> ()
    var onTapFavorite: () -> ()
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: dog.image)
                .resizable()
                .frame(width: UIScreen.main.bounds.width/2 - 4, height: 150)
                .scaledToFit()
            
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
