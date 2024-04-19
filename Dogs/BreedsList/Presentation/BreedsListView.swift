//
//  BreedsListView.swift
//  Dogs
//
//  Created by Youssef Ghattas on 24/03/2024.
//

import SwiftUI

struct BreedsListView: View {
    @State var store: BreedsStore
    
    var body: some View {
        VStack(spacing: 0) {
            if store.state.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity)
                    .padding(.top, 48)
            } else if store.state.filteredBreeds.isEmpty {
                Text("Can't find breeds.")
                    .font(.title)
            } else {
                List {
                    ForEach(store.state.filteredBreeds.keys.sorted(), id: \.self) { key in
                        Section(header: Text(key.capitalized)) {
                            ForEach(store.state.filteredBreeds[key]!.map { $0.toBreedViewModel }, id: \.name) { breed in
                                Button(
                                    action: {
                                        store.send(.open(breed.toBreedModel))
                                    },
                                    label: {
                                        BreedRow(breed: breed)
                                    }
                                )
                                .tint(.black)
                            }
                        }
                    }
                }
                .navigationTitle("Dogs")
                .searchable(text: $store.state.searchText)
                .onChange(of: store.state.searchText) { _, newValue in
                    store.send(.search(newValue))
                }
            }
        }
        .task {
            store.send(.onAppear)
        }
    }
}

private struct BreedRow: View {
    var breed: BreedViewModel
    
    var body: some View {
        HStack {
            Text(breed.name.capitalized)
                .fontWeight(.medium)
                .font(.title3)
            Spacer()
            Image(systemName: "chevron.right.circle.fill")
                .foregroundColor(.cyan)
        }
    }
}

#Preview {
    BreedsListView(
        store: BreedsStore(
            environment: BreedsEnvironment(
                repo: BreedsRepoStub(),
                router: BreedsRouterStub()
            )
        )
    )
}
