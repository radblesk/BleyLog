//
//  Projects.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

@Model
class Project {
    var title: String
    var projectNumber: Int?
    var date: Date
    var desc: String
    var icon: String?
    var lesson: Lesson?

    init(
        title: String,
        projectNumber: Int? = nil,
        date: Date,
        desc: String,
        icon: String? = nil,
        lesson: Lesson? = nil
    ) {
        self.title = title
        self.projectNumber = projectNumber
        self.date = date
        self.desc = desc
        self.icon = icon
        self.lesson = lesson
    }

    static func createDate(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return Calendar.current.date(from: components) ?? Date()
    }

    static let startingSwiftUI = [
        Project(
            title: "WeSplit",
            projectNumber: 1,
            date: createDate(year: 2025, month: 7, day: 8),
            desc: "A simple split app for splitting bills.",
            icon: "WeSplit-icon"
        ),
        Project(
            title: "TempConvert",
            projectNumber: 2,
            date: createDate(year: 2025, month: 7, day: 21),
            desc: "A simple temperature converter app.",
            icon: "TempConvert-icon"
        ),
        Project(
            title: "GuessTheFlag",
            projectNumber: 3,
            date: createDate(year: 2025, month: 8, day: 3),
            desc: "A simple flag guessing game.",
            icon: "GuessTheFlag-icon"
        ),
    ]

    static let consolidation2 = [
        Project(
            title: "RockPaperScissors",
            date: createDate(year: 2025, month: 8, day: 20),
            desc: "Rock, paper, scissors game.",
            icon: "RockPaperScissors-icon"
        )
    ]

    static let expandingYourSkills = [
        Project(
            title: "BetterRest",
            projectNumber: 4,
            date: createDate(year: 2025, month: 8, day: 20),
            desc:
                "App designed to help coffee drinkers get a good night’s sleep.",
            icon: "BetterRest-icon"
        ),
        Project(
            title: "Word Scramble",
            projectNumber: 5,
            date: createDate(year: 2025, month: 8, day: 26),
            desc:
                "The game will show players a random eight-letter word, and ask them to make words out of it.",
            icon: "WordScramble-icon"
        ),
        Project(
            title: "Animations",
            projectNumber: 6,
            date: createDate(year: 2025, month: 8, day: 26),
            desc:
                "This project is about learning how to use SwiftUI to create animations.",
            icon: "Animations-icon"
        ),
    ]

    static let consolidation3 = [
        Project(
            title: "Edutainment",
            date: createDate(year: 2025, month: 8, day: 26),
            desc:
                "App for kids to help them practice multiplication tables – “what is 7 x 8?” and so on..",
            icon: "Edutainment-icon"
        )
    ]

    static let scalingUpToBiggerApps = [
        Project(
            title: "iExpense",
            projectNumber: 7,
            date: createDate(year: 2025, month: 8, day: 26),
            desc:
                "Expense tracker that separates personal costs from business costs.",
            icon: "iExpense-icon"
        )
    ]
}
