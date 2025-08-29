//
//  Projects.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftUI

struct Language: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var courses: [Course] = []
}
