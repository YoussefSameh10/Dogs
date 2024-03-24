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
        case (.breeds, .breeds):
            return true
        case let(.dogs(lhsBreed), .dogs(rhsBreed)):
            return lhsBreed.name == rhsBreed.name
        case (.dogs(_), .breeds):
            return false
        case (.breeds, .dogs(_)):
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        
    }
    
    case breeds
    case dogs(Breed)
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
        case .breeds:
            pushBreedsListView()
        case .dogs(let breed):
            pushDogsListView(breed: breed)
        }
    }
    
    private func pushBreedsListView() -> AnyView {
        let viewModel = BreedsListViewModel()
        
        viewModel.goNext.sink { [weak self] breed in
            self?.navPath.append(Screen.dogs(breed))
        }
        .store(in: &viewModel.subscriptions)
        
        return BreedsListView(viewModel: viewModel).toAnyView
    }
    
    private func pushDogsListView(breed: Breed) -> AnyView {
        let viewModel = DogsListViewModel(breed: breed)
        return DogsListView(viewModel: viewModel).toAnyView
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

#Preview {
    BreedsRouterView(router: BreedsRouter())
}

extension View {
    var toAnyView: AnyView {
        AnyView(self)
    }
}
