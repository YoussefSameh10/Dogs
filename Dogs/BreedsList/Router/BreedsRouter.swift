//
//  BreedsRouter.swift
//  Dogs
//
//  Created by Youssef Ghattas on 24/03/2024.
//

import SwiftUI

@Observable @MainActor
class BreedsRouterImpl: BreedsRouter {
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
        let environment = DogsListEnvironment(router: self)
        
        let store = DogsListStore(breed: breed, environment: environment)
        return DogsListView(store: store).toAnyView
    }
    
    private func pushDogDetailsView(dog: DogModel) -> AnyView {
        return DogDetailsView(dog: dog).toAnyView
    }
}

extension BreedsRouterImpl: BreedsRouterDelegate {
    func goNext(breed: BreedModel) async {
        await MainActor.run { [weak self] in
            self?.navPath.append(Screen.dogsList(breed))
        }
    }
}

extension BreedsRouterImpl: DogsRouterDelegate {
    func goNext(dog: DogModel) async {
        await MainActor.run { [weak self] in
            self?.navPath.append(Screen.dog(dog))
        }
    }
}
