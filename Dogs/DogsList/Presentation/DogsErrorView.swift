//
//  DogsErrorView.swift
//  Dogs
//
//  Created by Youssef Ghattas on 26/04/2024.
//

import SwiftUI

struct DogsErrorView: View {
    var error: DogsUIError
    var body: some View {
        Text(error.description)
    }
}

#Preview {
    DogsErrorView(error: .network)
}
