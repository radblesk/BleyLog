//
//  ProjectDetailView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 19/08/2025.
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
                case "BetterRest":
                    BetterRest()
                default:
                    Text("Select a project")
                }
            }
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
