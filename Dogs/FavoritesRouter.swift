//
//  FavoritesRouter.swift
//  Dogs
//
//  Created by Youssef Ghattas on 29/03/2024.
//

import SwiftUI

@MainActor
class FavoritesRouter: ObservableObject {
    @Published var navPath = NavigationPath()
    @Published var firstScreen: AnyView!
    
    init() {
        firstScreen = pushFavoritesListView()
    }
    
    enum Screen: Hashable {
        case favoritesList
        case dog(DogViewModel)
        
        static func == (lhs: Screen, rhs: Screen) -> Bool {
            false
        }
        
        func hash(into hasher: inout Hasher) { }
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
        var environment = FavoritesEnvironment()
        
        environment.goNext.receive(on: DispatchQueue.main).sink { [weak self] dog in
            self?.navPath.append(Screen.dog(dog))
        }
        .store(in: &environment.subscriptions)
        
        let store = FavoritesStore(environment: environment)
        return FavoritesListView(store: store).toAnyView
    }
    
    private func pushDogDetailsView(dog: DogViewModel) -> AnyView {
        return DogDetailsView(dog: dog).toAnyView
    }
}


struct FavoritesRouterView: View {
    @ObservedObject var router: FavoritesRouter
    var body: some View {
        NavigationStack(path: $router.navPath) {
            router.firstScreen
                .navigationDestination(for: FavoritesRouter.Screen.self) { screen in
                    router.screenFor(screen)
                }
        }
    }
}
