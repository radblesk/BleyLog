//
//  SheetView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 18/08/2025.
//

import HighlightSwift
import SwiftUI

struct SheetView: View {
    @Binding var isPresenting: Bool
    var project: String

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                CodeText(
                    CodeSnippets.snippets[project]
                        ?? "No code snippet found for \(project)"
                )
                .highlightLanguage(.swift)
                .codeTextColors(.theme(.xcode))
                .padding(.top, 130)
                .padding(.bottom, 50)
            }
            .padding(.horizontal)
            .ignoresSafeArea()
            .textSelection(.enabled)
            .font(.caption2)
            .navigationTitle("Source Code")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                .listStyle(.insetGrouped)
            #else
                .listStyle(.inset)
            #endif
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button("Close", systemImage: "xmark") {
                        isPresenting = false
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    SheetView(isPresenting: .constant(true), project: "weSplit")
}
