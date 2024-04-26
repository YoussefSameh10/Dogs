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
        case .breedsError(let error):
            pushBreedsErrorView(error: error)
        case .dogsError(let error):
            pushDogsErrorView(error: error)
        }
    }
    
    private func pushBreedsListView() -> AnyView {
        let environment = BreedsEnvironment(router: self)
        
        let store = BreedsStore(environment: environment)
        
        return BreedsListView(store: store).toAnyView
    }
    
    private func pushDogsListView(breed: BreedModel) -> AnyView {
        let environment = DogsListEnvironment(router: self)
        
        let store = DogsListStore(breed: breed.toBreedViewModel, environment: environment)
        return DogsListView(store: store).toAnyView
    }
    
    private func pushDogDetailsView(dog: DogModel) -> AnyView {
        let environment = DogDetailsEnvironment()
        let store = DogDetailsStore(dog: dog.toDogViewModel, environment: environment)
        return DogDetailsView(store: store).toAnyView
    }
    
    private func pushBreedsErrorView(error: BreedsError) -> AnyView {
        let environment = BreedsErrorEnvironment(router: self)
        let store = BreedsErrorStore(error: error.toUIError, environment: environment)
        return BreedsErrorView(store: store).toAnyView
    }
    
    private func pushDogsErrorView(error: DogsError) -> AnyView {
        DogsErrorView(error: error.toUIError).toAnyView
    }
}

extension BreedsRouterImpl: BreedsRouterDelegate {
    func goNext(breed: BreedModel) async {
        await MainActor.run { [weak self] in
            self?.navPath.append(Screen.dogsList(breed))
        }
    }
    
    func showBreedsError(_ error: BreedsError) async {
        await MainActor.run { [weak self] in
            self?.firstScreen = self?.pushBreedsErrorView(error: error).toAnyView
        }
    }
}

extension BreedsRouterImpl: DogsRouterDelegate {
    func goNext(dog: DogModel) async {
        await MainActor.run { [weak self] in
            self?.navPath.append(Screen.dog(dog))
        }
    }
    
    func showDogsError(_ error: DogsError) async {
        await MainActor.run { [weak self] in
            self?.navPath.removeLast()
            self?.navPath.append(Screen.dogsError(error))
        }
    }
}

extension BreedsRouterImpl: BreedsErrorRouterDelegate {
    func dismissBreedsError() async {
        await MainActor.run { [weak self] in
            self?.firstScreen = self?.pushBreedsListView()
        }
    }
}
