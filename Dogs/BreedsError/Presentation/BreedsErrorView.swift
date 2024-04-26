//
//  BreedsErrorView.swift
//  Dogs
//
//  Created by Youssef Ghattas on 20/04/2024.
//

import SwiftUI

struct BreedsErrorView: View {
    @State var store: BreedsErrorStore
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(store.state.error.toUIError.description)
                .font(.title2)
                .padding(.horizontal)
        }
    }
}

#Preview("Network Error") {
    BreedsErrorView(
        store: BreedsErrorStore(
            error: .network,
            environment: BreedsErrorEnvironment(router: BreedsErrorRouterStub())
        )
    )
}

#Preview("Unknown Error") {
    BreedsErrorView(
        store: BreedsErrorStore(
            error: .unknown,
            environment: BreedsErrorEnvironment(router: BreedsErrorRouterStub())
        )
    )
}
