//
//  Projects.swift
//  HWS
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

@Model
class Project {
    var title: String
    var projectNumber: Int
    var date: Date
    var desc: String

    init(
        title: String,
        projectNumber: Int,
        date: Date,
        desc: String
    ) {
        self.title = title
        self.projectNumber = projectNumber
        self.date = date
        self.desc = desc
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
            desc: "A simple split app for splitting bills."
        ),
        Project(
            title: "TempConvert",
            projectNumber: 2,
            date: createDate(year: 2025, month: 7, day: 21),
            desc: "A simple temperature converter app."
        ),
        Project(
            title: "GuessTheFlag",
            projectNumber: 3,
            date: createDate(year: 2025, month: 8, day: 3),
            desc: "A simple flag guessing game."
        ),
    ]
}
