//
//  ContentView.swift
//  BleyLog for Mac
//
//  Created by Radoslav Bley on 20/08/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CoursesSplitView()
    }
}

#Preview {
    let viewModel = ViewModel()
    ContentView()
        .environment(viewModel)
}
