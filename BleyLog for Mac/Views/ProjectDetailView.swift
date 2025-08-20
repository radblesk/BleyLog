//
//  ProjectDetailView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 13/08/2025.
//

import SwiftUI

struct ProjectDetailView: View {
    // DataModel
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
                case "RockPaperScissors":
                    RockPaperScissors()
                default:
                    Text("Select a project")
                }
            }
            .padding()
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
