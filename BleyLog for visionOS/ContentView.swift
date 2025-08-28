//
//  ContentView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
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
