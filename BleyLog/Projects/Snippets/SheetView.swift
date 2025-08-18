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
            Form {
                CodeText(
                    CodeSnippets.snippets[project]
                        ?? "No code snippet found for \(project)"
                )
                .highlightLanguage(.swift)
                .codeTextColors(.theme(.xcode))
                .toolbar {
                    ToolbarItem(placement: .destructiveAction) {
                        Button("Close", systemImage: "xmark") {
                            isPresenting = false
                        }
                    }
                }
                .navigationTitle("Source Code")
                #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                #endif
            }
            .font(.callout)
        }
        .presentationDetents([.medium, .large])
    }
}
