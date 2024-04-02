//
//  FavoritesRouterView.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

import SwiftUI

@MainActor
protocol FavoritesRouter {
    var navPath: NavigationPath { get set }
    var firstScreen: AnyView! { get }
    
    func screenFor(_ screen: FavoritesRouterImpl.Screen) -> AnyView
}

struct FavoritesRouterView: View {
    @State var router: FavoritesRouter
    var body: some View {
        NavigationStack(path: $router.navPath) {
            router.firstScreen
                .navigationDestination(for: FavoritesRouterImpl.Screen.self) { screen in
                    router.screenFor(screen)
                }
        }
    }
}
