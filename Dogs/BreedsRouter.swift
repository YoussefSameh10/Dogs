//
//  BreedsRouter.swift
//  Dogs
//
//  Created by Youssef Ghattas on 24/03/2024.
//

import SwiftUI

enum Screen: Hashable {
    static func == (lhs: Screen, rhs: Screen) -> Bool {
        switch (lhs, rhs) {
        case (.breedsList, .breedsList):
            return true
        case let(.dogsList(lhsBreed), .dogsList(rhsBreed)):
            return lhsBreed.name == rhsBreed.name
        case (.dogsList(_), .breedsList):
            return false
        case (.breedsList, .dogsList(_)):
            return false
        case (.dog(let dog), _):
            return false
        case (_, .dog(let dog)):
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) { }
    
    case breedsList
    case dogsList(Breed)
    case dog(DogViewModel)
}

@MainActor
class BreedsRouter: ObservableObject {
    @Published var navPath = NavigationPath()
    @Published var firstScreen: AnyView!
    
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
            pushDogView(dog: dog)
        }
    }
    
    private func pushBreedsListView() -> AnyView {
        var environment = BreedsEnvironment()
        
        environment.goNext.receive(on: DispatchQueue.main).sink { [weak self] breed in
            self?.navPath.append(Screen.dogsList(breed))
        }
        .store(in: &environment.subscriptions)
        
        let store = BreedsStore(environment: environment)
        
        return BreedsListView(store: store).toAnyView
    }
    
    private func pushDogsListView(breed: Breed) -> AnyView {
        var environment = DogsEnvironment()
        
        environment.goNext.receive(on: DispatchQueue.main).sink { [weak self] dog in
            self?.navPath.append(Screen.dog(dog))
        }
        .store(in: &environment.subscriptions)
        
        let store = DogsStore(breed: breed, environment: environment)
        return DogsListView(store: store).toAnyView
    }
    
    private func pushDogView(dog: DogViewModel) -> AnyView {
        return DogView(dog: dog, isFavorite: false, onTapDog: { }, onTapFavorite: { }).toAnyView
    }
}

struct BreedsRouterView: View {
    @ObservedObject var router: BreedsRouter
    var body: some View {
        NavigationStack(path: $router.navPath) {
            router.firstScreen
                .navigationDestination(for: Screen.self) { screen in
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
