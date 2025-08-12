//
//  DaysListSection.swift
//  HWS
//
//  Created by Radoslav Bley on 12/08/2025.
//

import SwiftUI

struct DaysListSection: View {
    var groupedDays: [Days]
    var course: Courses

    @State private var isExpanded = true

    var body: some View {
        Section(course.title, isExpanded: $isExpanded) {
            ForEach(groupedDays) { day in
                HStack {
                    if day.finished {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.green)
                    }
                    Text(
                        "Days \(day.firstDay)-\(day.lastDay): \(day.title)"
                    )
                }
                .tag(day.firstDay)
            }
        }
    }
}
