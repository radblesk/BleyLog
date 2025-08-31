//
//  ProjectView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 26/08/2025.
//

import SwiftUI

struct ProjectView {
    let project: Project

    @MainActor @ViewBuilder func viewForProject() -> some View {
        switch project.title {
        case "WeSplit": WeSplit()
        case "TempConvert": TempConvert()
        case "GuessTheFlag": GuessTheFlag()
        case "RockPaperScissors": RockPaperScissors()
        case "BetterRest": BetterRest()
        case "Word Scramble": WordScramble()
        case "Animations": Animations()
        case "Edutainment": Edutainment()
        case "iExpense": iExpense()
        case "Moonshot": Moonshot()
        case "Navigation": Navigation()
        case "Habits": Habits()
        case "CupcakeCorner": CupcakeCorner()
        case "Bookworm": Bookworm()
        case "SwiftData": SwiftDataProject()
        default: Text("Select a project")
        }
    }
}
