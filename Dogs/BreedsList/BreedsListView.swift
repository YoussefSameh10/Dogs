//
//  BreedsListView.swift
//  Dogs
//
//  Created by Youssef Ghattas on 24/03/2024.
//

import SwiftUI
import Combine

@MainActor
class BreedsListViewModel: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    var goNext = PassthroughSubject<Breed, Never>()
    
    @Published var breeds = [Breed]()
    
    func fetchBreeds() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://dog.ceo/api/breeds/list/all")!)
            breeds = try JSONDecoder().decode(BreedsResponse.self, from: data).breeds.sorted(by: { $0.name < $1.name })
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct BreedsListView: View {
    @ObservedObject var viewModel: BreedsListViewModel
    
    
    var body: some View {
        List(viewModel.breeds, id: \.name) { breed in
            Button(
                action: {
                    viewModel.goNext.send(breed)
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
        .task {
            await viewModel.fetchBreeds()
        }
    }
}

#Preview {
    BreedsListView(viewModel: BreedsListViewModel())
}
