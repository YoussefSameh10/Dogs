//
//  DogsListView.swift
//  Dogs
//
//  Created by Youssef Ghattas on 24/03/2024.
//

import SwiftUI

@MainActor
class DogsListViewModel: ObservableObject {
    @Published var dogsImages = [UIImage]()
    let breed: Breed
    
    init(breed: Breed) {
        self.breed = breed
    }
    
    func fetchDogs() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://dog.ceo/api/breed/\(breed.name)/images")!)
            let dogsURLs = try JSONDecoder().decode(DogResponse.self, from: data).images.map { URL(string: $0)! }
            var tempImages = [UIImage]()
            for url in dogsURLs {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    tempImages.append(image)
                }
            }
            dogsImages = tempImages
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct DogsListView: View {
    @ObservedObject var viewModel: DogsListViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: UIScreen.main.bounds.width/2 - 4))], spacing: 8) {
                ForEach(viewModel.dogsImages, id: \.hashValue) { image in
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width/2 - 4, height: 150)
                        .scaledToFit()
                }
            }
        }
        .background(content: { Color.gray.opacity(0.2) })
        .task {
            await viewModel.fetchDogs()
        }
    }
}

#Preview {
    DogsListView(viewModel: DogsListViewModel(breed: Breed(name: "Eskimo")))
}
