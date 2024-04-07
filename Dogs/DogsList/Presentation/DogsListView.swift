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
                    ForEach(store.state.dogs.map { $0.toDogViewModel }) { dog in
                        DogView(
                            dog: dog,
                            isFavorite: dog.isFavorite,
                            onTapDog: {
                                store.send(.tapDog(dog.toDogModel))
                            },
                            onTapFavorite: { store.send(.tapFavorites(dog.toDogModel)) }
                        )
                    }
                }
                .navigationTitle(store.state.breed.toBreedViewModel.name.capitalized)
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
            breed: BreedViewModel(name: "Husky"),
            environment: DogsListEnvironment(
                repo: DogsRepoStub(),
                router: DogsRouterStub()
            )
        )
    )
}
