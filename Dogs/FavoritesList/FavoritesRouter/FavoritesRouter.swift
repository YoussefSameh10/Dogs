//
//  FavoritesRouter.swift
//  Dogs
//
//  Created by Youssef Ghattas on 29/03/2024.
//

import SwiftUI

@Observable @MainActor
class FavoritesRouterImpl: FavoritesRouter {
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
        let environment = FavoritesListEnvironment(router: self)
        
        let store = FavoritesListStore(environment: environment)
        return FavoritesListView(store: store).toAnyView
    }
    
    private func pushDogDetailsView(dog: DogModel) -> AnyView {
        return DogDetailsView(dog: dog).toAnyView
    }
}

extension FavoritesRouterImpl: FavoritesRouterDelegate {
    func goNext(dog: DogModel) async {
        await MainActor.run { [weak self] in
            self?.navPath.append(Screen.dog(dog))
        }
    }
}
