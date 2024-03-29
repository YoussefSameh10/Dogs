//
//  DogDetailsView.swift
//  Dogs
//
//  Created by Youssef Ghattas on 29/03/2024.
//

import SwiftUI

struct DogDetailsView: View {
    var dog: DogViewModel
    @GestureState var scale = 1.0
    
    var magnifyGesture: some Gesture {
        MagnifyGesture().updating($scale) { value, gestureState, _ in
            gestureState = value.magnification
        }
    }
    
    var body: some View {
        VStack() {
            Text(dog.id)
                .font(.title)
            
            Spacer()
                .frame(height: 32)
            
            Image(uiImage: dog.image)
                .resizable()
                .scaledToFit()
                .scaleEffect(scale)
                .gesture(magnifyGesture)
            
            Spacer()
        }
    }
}

#Preview {
    DogDetailsView(dog: DogViewModel(id: "Huskey", image: UIImage(systemName: "dog")!))
}
