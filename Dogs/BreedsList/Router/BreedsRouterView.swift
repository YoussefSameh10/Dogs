//
//  BreedsRouterView.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

import SwiftUI

@MainActor
protocol BreedsRouter {
    var navPath: NavigationPath { get set }
    var firstScreen: AnyView! { get }
    
    func screenFor(_ screen: BreedsRouterImpl.Screen) -> AnyView
}

struct BreedsRouterView: View {
    @State var router: BreedsRouter
    var body: some View {
        NavigationStack(path: $router.navPath) {
            router.firstScreen
                .navigationDestination(for: BreedsRouterImpl.Screen.self) { screen in
                    router.screenFor(screen)
                }
        }
    }
}
