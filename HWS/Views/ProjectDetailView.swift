//
//  ProjectDetailView.swift
//  HWS
//
//  Created by Radoslav Bley on 13/08/2025.
//

import SwiftUI

struct ProjectDetailView: View {
    var selectedProject: Project?

    var body: some View {
        NavigationStack {
            Group {
                switch selectedProject?.title {
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
        selectedProject: Project(
            title: "WeSplit",
            projectNumber: 1,
            date: Date(),
            desc: ""
        )
    )
}
