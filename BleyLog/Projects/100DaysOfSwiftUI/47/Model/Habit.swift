//
//  Habit.swift
//  BleyLog
//
//  Created by Radoslav Bley on 01/09/2025.
//

import Foundation
import SwiftData

@Model
class Habit {
    var title: String = ""
    var habitDescription: String = ""
    var days: Int = 0

    init(title: String, habitDescription: String, days: Int) {
        self.title = title
        self.habitDescription = habitDescription
        self.days = days
    }
}
