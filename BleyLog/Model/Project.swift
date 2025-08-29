//
//  Projects.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftUI

struct Project: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var projectNumber: Int?
    var date: Date
    var desc: String
    var icon: String?
    var lesson: Lesson?
}
