//
//  BreedsRouter.swift
//  Dogs
//
//  Created by Youssef Ghattas on 24/03/2024.
//

import SwiftUI

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
            pushDogDetailsView(dog: dog)
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
    
    private func pushDogDetailsView(dog: DogViewModel) -> AnyView {
        return DogDetailsView(dog: dog).toAnyView
    }
}

struct BreedsRouterView: View {
    @ObservedObject var router: BreedsRouter
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
