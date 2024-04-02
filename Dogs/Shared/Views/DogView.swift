//
//  DogView.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

import SwiftUI

struct DogView: View {
    var dog: DogModel
    var isFavorite: Bool
    var onTapDog: () -> ()
    var onTapFavorite: () -> ()
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: dog.image)
                .resizable()
                .frame(width: UIScreen.main.bounds.width/2 - 4, height: 150)
                .scaledToFit()
                .onTapGesture {
                    onTapDog()
                }
            
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
