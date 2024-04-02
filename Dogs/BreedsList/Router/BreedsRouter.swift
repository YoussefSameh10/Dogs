//
//  BreedsRouter.swift
//  Dogs
//
//  Created by Youssef Ghattas on 24/03/2024.
//

import SwiftUI

@Observable @MainActor
class BreedsRouter {
    var navPath = NavigationPath()
    var firstScreen: AnyView!
    
    init() {
        firstScreen = pushBreedsListView()
    }
    
    func screenFor(_ screen: Screen) -> AnyView {
        switch screen {
        case .breedsList:
            pushBreedsListView()
        case .dogsList(let breed):
            pushDogsListView(breed: breed)
        case .dog(let dog):
            pushDogDetailsView(dog: dog)
        }
    }
    
    private func pushBreedsListView() -> AnyView {
        let environment = BreedsEnvironment(router: self)
        
        let store = BreedsStore(environment: environment)
        
        return BreedsListView(store: store).toAnyView
    }
    
    private func pushDogsListView(breed: BreedModel) -> AnyView {
        let environment = DogsEnvironment(router: self)
        
        let store = DogsStore(breed: breed, environment: environment)
        return DogsListView(store: store).toAnyView
    }
    
    private func pushDogDetailsView(dog: DogModel) -> AnyView {
        return DogDetailsView(dog: dog).toAnyView
    }
}

struct BreedsRouterView: View {
    @State var router: BreedsRouter
    var body: some View {
        NavigationStack(path: $router.navPath) {
            router.firstScreen
                .navigationDestination(for: BreedsRouter.Screen.self) { screen in
                    router.screenFor(screen)
                }
        }
    }
}

extension View {
    var toAnyView: AnyView {
        AnyView(self)
    }
}

extension BreedsRouter: BreedsRouterDelegate {
    func goNext(breed: BreedModel) async {
        await MainActor.run { [weak self] in
            self?.navPath.append(Screen.dogsList(breed))
        }
    }
}

extension BreedsRouter: DogsRouterDelegate {
    func goNext(dog: DogModel) async {
        await MainActor.run { [weak self] in
            self?.navPath.append(Screen.dog(dog))
        }
    }
}
