//
//  ForYouView.swift
//  HWS
//
//  Created by Radoslav Bley on 18/08/2025.
//

import SwiftData
import SwiftUI

struct ForYouView: View {
    @Query private var lessons: [Lesson]

    var body: some View {
        NavigationStack {
            List {
                let lessonsForYou = lessons.filter { $0.inProgress == true }
                if lessonsForYou.count > 0 {
                    ForEach(
                        lessons.filter { $0.inProgress == true },
                        id: \.self
                    ) {
                        lesson in
                        NavigationLink {
                            ProjectList(
                                selectedLesson: lesson,
                                selectedProject: .constant(nil)
                            )
                        } label: {
                            Label(
                                "Days \(lesson.firstDay)-\(lesson.lastDay): \(lesson.title)",
                                systemImage: "book.pages.fill"
                            )
                        }
                    }
                } else {
                    Text("Nothing to show...")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("For You")
        }
    }
}

#Preview {
    ForYouView()
}
