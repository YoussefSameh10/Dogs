//
//  DogDetailsView.swift
//  Dogs
//
//  Created by Youssef Ghattas on 29/03/2024.
//

import SwiftUI

struct DogDetailsView: View {
    var dog: DogModel
    @GestureState var scale = 1.0
    
    var magnifyGesture: some Gesture {
        MagnifyGesture().updating($scale) { value, gestureState, _ in
            gestureState = value.magnification
        }
    }
    
    var body: some View {
        ScrollView {
            VStack() {
                Image(uiImage: dog.image)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(scale)
                    .gesture(magnifyGesture)
                
                Spacer()
            }
        }
        .navigationTitle(dog.breed.name.capitalized)
    }
}

#Preview {
    DogDetailsView(dog: DogModel(id: "Huskey", breed: BreedModel(name: "Huskey"), image: UIImage(systemName: "dog")!))
}
