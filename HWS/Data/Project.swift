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
    var date: Date  // 1. Added date property

    init(title: String, projectNumber: Int, date: Date) {
        self.title = title
        self.projectNumber = projectNumber
        self.date = date
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
            date: createDate(year: 2025, month: 7, day: 8)
        ),
        Project(
            title: "TempConvert",
            projectNumber: 2,
            date: createDate(year: 2025, month: 7, day: 21)
        ),
        Project(
            title: "GuessTheFlag",
            projectNumber: 3,
            date: createDate(year: 2025, month: 8, day: 3)
        ),
    ]
}
