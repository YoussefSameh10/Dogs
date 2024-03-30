//
//  BreedsListView.swift
//  Dogs
//
//  Created by Youssef Ghattas on 24/03/2024.
//

import SwiftUI
import Combine

struct BreedsListView: View {
    @State var store: BreedsStore
    
    var body: some View {
        VStack(spacing: 0) {
            if store.state.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity)
                    .padding(.top, 48)
            } else {
                List {
                    ForEach(store.state.filteredBreeds.keys.sorted(), id: \.self) { key in
                        Section(header: Text(key.capitalized)) {
                            ForEach(store.state.filteredBreeds[key]!, id: \.name) { breed in
                                Button(
                                    action: {
                                        store.send(.open(breed))
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
                .onChange(of: store.state.searchText) { oldValue, newValue in
                    store.send(.search(newValue))
                }
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

private struct BreedRow: View {
    var breed: Breed
    
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
    BreedsListView(store: BreedsStore(environment: BreedsEnvironment()))
}
