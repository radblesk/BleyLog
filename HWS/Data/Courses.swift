//
//  Projects.swift
//  HWS
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

@Model
class Courses {
    var title: String
    var footer: String?

    init(title: String, footer: String? = nil) {
        self.title = title
        self.footer = footer
    }

    static let coursesData = [
        Courses(
            title: "100 days of SwiftUI",
            footer:
                "Course by Paul Hudson [Learn more...](https://www.hackingwithswift.com/100/swiftui)"
        ),
        Courses(
            title: "100 days of Swift",
            footer:
                "Course by Paul Hudson [Learn more...](https://www.hackingwithswift.com/100)"
        ),
    ]
}
