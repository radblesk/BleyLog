//
//  ProjectData.swift
//  BleyLog
//
//  Created by Radoslav Bley on 29/08/2025.
//

import Foundation

extension Project {
    static let exampleProject = expandingYourSkills[1]
    
    static func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components) ?? Date()
    }

    static let startingSwiftUI = [
        Project(
            title: "WeSplit",
            projectNumber: 1,
            date: createDate(year: 2025, month: 7, day: 8, hour: 07, minute: 44),
            desc: "A simple split app for splitting bills.",
            icon: "WeSplit-icon"
        ),
        Project(
            title: "TempConvert",
            projectNumber: 2,
            date: createDate(year: 2025, month: 7, day: 21, hour: 15, minute: 54),
            desc: "A simple temperature converter app.",
            icon: "TempConvert-icon"
        ),
        Project(
            title: "GuessTheFlag",
            projectNumber: 3,
            date: createDate(year: 2025, month: 8, day: 3, hour: 14, minute: 30),
            desc: "A simple flag guessing game.",
            icon: "GuessTheFlag-icon"
        ),
    ]

    static let consolidation2 = [
        Project(
            title: "RockPaperScissors",
            date: createDate(year: 2025, month: 8, day: 20, hour: 16, minute: 26),
            desc: "Rock, paper, scissors game.",
            icon: "RockPaperScissors-icon"
        )
    ]

    static let expandingYourSkills = [
        Project(
            title: "BetterRest",
            projectNumber: 4,
            date: createDate(year: 2025, month: 8, day: 20, hour: 18, minute: 59),
            desc:
                "App designed to help coffee drinkers get a good night’s sleep.",
            icon: "BetterRest-icon"
        ),
        Project(
            title: "Word Scramble",
            projectNumber: 5,
            date: createDate(year: 2025, month: 8, day: 26, hour: 14, minute: 04),
            desc:
                "The game will show players a random eight-letter word, and ask them to make words out of it.",
            icon: "WordScramble-icon"
        ),
        Project(
            title: "Animations",
            projectNumber: 6,
            date: createDate(year: 2025, month: 8, day: 26, hour: 16, minute: 01),
            desc:
                "This project is about learning how to use SwiftUI to create animations.",
            icon: "Animations-icon"
        ),
    ]

    static let consolidation3 = [
        Project(
            title: "Edutainment",
            date: createDate(year: 2025, month: 8, day: 26, hour: 19, minute: 47),
            desc:
                "App for kids to help them practice multiplication tables – “what is 7 x 8?” and so on..",
            icon: "Edutainment-icon"
        )
    ]

    static let scalingUpToBiggerApps = [
        Project(
            title: "iExpense",
            projectNumber: 7,
            date: createDate(year: 2025, month: 8, day: 26, hour: 14, minute: 36),
            desc:
                "Expense tracker that separates personal costs from business costs.",
            icon: "iExpense-icon"
        ),
        Project(
            title: "Moonshot",
            projectNumber: 8,
            date: createDate(year: 2025, month: 8, day: 27, hour: 20, minute: 01),
            desc:
                "App that lets users learn about the missions and astronauts that formed NASA’s Apollo space program.",
            icon: "Moonshot-icon"
        ),
        Project(
            title: "Navigation",
            projectNumber: 9,
            date: createDate(year: 2025, month: 08, day: 28, hour: 09, minute: 41),
            desc:
                "In this technique project we’re going to take a close look at navigation in SwiftUI",
            icon: "Navigation-icon"
        ),
    ]

    static let consolidation4 = [
        Project(
            title: "Habits",
            date: createDate(year: 2025, month: 08, day: 28, hour: 13, minute: 24),
            desc:
                "A habit-tracking app, for folks who want to keep track of how much they do certain things.",
            icon: "Habits-icon"
        )
    ]

    static let focusOnData = [
        Project(
            title: "CupcakeCorner",
            projectNumber: 10,
            date: createDate(year: 2025, month: 08, day: 28, hour: 19, minute: 29),
            desc: "A multi-screen app for ordering cupcakes",
            icon: "CupcakeCorner-icon"
        )
    ]
}
