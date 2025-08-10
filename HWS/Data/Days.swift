//
//  Projects.swift
//  HWS
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

@Model
class Days {
    var firstDay: Int
    var lastDay: Int
    var title: String
    var courseName: String
    var finished: Bool = false

    init(
        firstDay: Int,
        lastDay: Int,
        title: String,
        courseName: String,
        finished: Bool = false
    ) {
        self.firstDay = firstDay
        self.lastDay = lastDay
        self.title = title
        self.courseName = courseName
        self.finished = finished
    }

    static let daysData = [
        Days(
            firstDay: 16,
            lastDay: 24,
            title: "Starting SwiftUI",
            courseName: "100 days of SwiftUI"
        ),
        Days(
            firstDay: 26,
            lastDay: 34,
            title: "Expanding your skills",
            courseName: "100 days of SwiftUI"
        ),
        Days(
            firstDay: 36,
            lastDay: 46,
            title: "Scaling up to bigger apps",
            courseName: "100 days of SwiftUI"
        ),
        Days(
            firstDay: 49,
            lastDay: 59,
            title: "Focus on data",
            courseName: "100 days of SwiftUI"
        ),
        Days(
            firstDay: 62,
            lastDay: 76,
            title: "Filters, maps, and more",
            courseName: "100 days of SwiftUI"
        ),
        Days(
            firstDay: 79,
            lastDay: 94,
            title: "Controlling UI flow",
            courseName: "100 days of SwiftUI"
        ),
        Days(
            firstDay: 96,
            lastDay: 99,
            title: "One last project",
            courseName: "100 days of SwiftUI"
        ),
    ]
}
