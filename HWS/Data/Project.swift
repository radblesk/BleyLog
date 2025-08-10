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
    var startingDay: Int
    var date: Date  // 1. Added date property

    init(title: String, projectNumber: Int, startingDay: Int, date: Date) {  // 2. Updated initializer
        self.title = title
        self.projectNumber = projectNumber
        self.startingDay = startingDay
        self.date = date
    }

    // 3. A simple helper function to create dates
    static func createDate(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return Calendar.current.date(from: components) ?? Date()
    }

    // 4. Updated sample data with specific dates
    static let projectsData = [
        Project(
            title: "WeSplit",
            projectNumber: 1,
            startingDay: 16,
            date: createDate(year: 2025, month: 7, day: 8)
        ),
        Project(
            title: "TempConvert",
            projectNumber: 2,
            startingDay: 16,
            date: createDate(year: 2025, month: 7, day: 21)
        ),
        Project(
            title: "GuessTheFlag",
            projectNumber: 3,
            startingDay: 16,
            date: createDate(year: 2025, month: 8, day: 3)
        ),
        Project(
            title: "Test",
            projectNumber: 4,
            startingDay: 25,
            date: createDate(year: 2025, month: 8, day: 1)
        ),
    ]
}
