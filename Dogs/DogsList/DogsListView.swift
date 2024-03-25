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
                    ForEach(store.state.dogs, id: \.hashValue) { image in
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width/2 - 4, height: 150)
                            .scaledToFit()
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
//
//#Preview {
//    DogsListView(viewModel: DogsListViewModel(breed: Breed(name: "Eskimo")))
//}
