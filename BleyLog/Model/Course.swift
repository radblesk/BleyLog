//
//  Projects.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftUI

struct Course: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var language: Language?
    var lessons: [Lesson] = []
}
