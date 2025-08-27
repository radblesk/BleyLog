//
//  ContentView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 19/08/2025.
//

import SwiftUI

struct ContentView: View {
    // MARK: Environments
    /// ViewModel
    @Environment(ViewModel.self) var viewModel

    var body: some View {
        CoursesSplitView()
    }
}

// MARK: - Preview
#Preview {
    let viewModel = ViewModel()

    ContentView()
        .environment(viewModel)
}
