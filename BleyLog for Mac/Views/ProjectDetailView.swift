//
//  ProjectDetailView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 13/08/2025.
//

import SwiftUI

struct ProjectDetailView: View {
    @Environment(ViewModel.self) var viewModel
    // DataModel
    var projectID: Project.ID?

    var body: some View {
        NavigationStack {
            Group {
                if let id = projectID, let project = viewModel.project(for: id)
                {
                    switch project.title {
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
            .scenePadding()
        }
        .frame(maxWidth: 500)
    }
}
