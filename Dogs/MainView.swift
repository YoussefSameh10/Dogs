//
//  MainView.swift
//  Dogs
//
//  Created by Youssef Ghattas on 24/03/2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            BreedsRouterView(router: BreedsRouterImpl())
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("All")
                    }
                }
            FavoritesRouterView(router: FavoritesRouterImpl())
                .tabItem {
                    VStack {
                        Image(systemName: "star.fill")
                        Text("Favorites")
                    }
                }
        }
        .tint(Color.cyan)
    }
}

#Preview {
    MainView()
}
