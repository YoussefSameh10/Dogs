//
//  FavoritesRouter.swift
//  Dogs
//
//  Created by Youssef Ghattas on 29/03/2024.
//

import SwiftUI

@Observable @MainActor
class FavoritesRouter {
    var navPath = NavigationPath()
    var firstScreen: AnyView!
    
    init() {
        firstScreen = pushFavoritesListView()
    }
    
    func screenFor(_ screen: Screen) -> AnyView {
        switch screen {
        case .favoritesList:
            pushFavoritesListView()
        case .dog(let dog):
            pushDogDetailsView(dog: dog)
        }
    }
    
    private func pushFavoritesListView() -> AnyView {
        var environment = FavoritesEnvironment(router: self)
        
        let store = FavoritesStore(environment: environment)
        return FavoritesListView(store: store).toAnyView
    }
    
    private func pushDogDetailsView(dog: DogModel) -> AnyView {
        return DogDetailsView(dog: dog).toAnyView
    }
}

struct FavoritesRouterView: View {
    @State var router: FavoritesRouter
    var body: some View {
        NavigationStack(path: $router.navPath) {
            router.firstScreen
                .navigationDestination(for: FavoritesRouter.Screen.self) { screen in
                    router.screenFor(screen)
                }
        }
    }
}

extension FavoritesRouter: FavoritesRouterDelegate {
    func goNext(dog: DogModel) async {
        await MainActor.run { [weak self] in
            self?.navPath.append(Screen.dog(dog))
        }
    }
}
