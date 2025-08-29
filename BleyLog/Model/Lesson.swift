//
//  Projects.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftUI

struct Lesson: Identifiable, Codable, Hashable {
    var id: String {
        return "\(title)_\(firstDay)_\(lastDay)"
    }
    var firstDay: Int
    var lastDay: Int
    var title: String
    var inProgress: Bool = false
    var finished: Bool = false
    var projects: [Project] = []
    var headerImage: String? = nil
    var course: Course?
}
