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

    init(
        title: String,
        projectNumber: Int? = nil,
        date: Date,
        desc: String,
        icon: String? = nil
    ) {
        self.title = title
        self.projectNumber = projectNumber
        self.date = date
        self.desc = desc
        self.icon = icon
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
        )
    ]
}
