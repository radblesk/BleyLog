//
//  ProjectView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 26/08/2025.
//

import SwiftUI

struct ProjectView: View {
    @Environment(ViewModel.self) var viewModel
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
                case "Word Scramble":
                    WordScramble()
                case "Animations":
                    Animations()
                case "Edutainment":
                    Edutainment()
                default:
                    Text("Select a project")
                }
            }
        }
    }
}
