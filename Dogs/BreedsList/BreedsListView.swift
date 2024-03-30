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
                List(store.state.breeds, id: \.name) { breed in
                    Button(
                        action: {
                            store.send(.open(breed))
                        },
                        label: {
                            HStack {
                                Text(breed.name.capitalized)
                                    .fontWeight(.medium)
                                    .font(.title3)
                                Spacer()
                                Image(systemName: "chevron.right.circle.fill")
                                    .foregroundColor(.cyan)
                            }
                        }
                    )
                    .tint(.black)
                }
                .navigationTitle("Dogs")
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    BreedsListView(store: BreedsStore(environment: BreedsEnvironment()))
}
