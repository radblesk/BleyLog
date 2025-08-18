//
//  ProjectDetailView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 13/08/2025.
//

import SwiftUI

struct ProjectDetailView: View {
    var project: Project?

    var body: some View {
        NavigationStack {
            Group {
                switch project?.title {
                case "WeSplit":
                    WeSplit()
                case "TempConvert":
                    TempConvert()
                case "GuessTheFlag":
                    GuessTheFlag()
                default:
                    Text("Select a project")
                }
            }
            // Apply the conditional modifier only once.
            #if os(macOS)
                .padding()
            #endif
        }
    }
}

#Preview {
    ProjectDetailView(
        project: Project(
            title: "WeSplit",
            projectNumber: 1,
            date: Date(),
            desc: ""
        )
    )
}
