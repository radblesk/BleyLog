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
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            List {
                let lessonsForYou = lessons.filter { $0.inProgress == true }
                let filteredLessons = lessonsForYou.filter {
                    $0.title.lowercased().contains(searchText.lowercased())
                }

                if searchText.isEmpty {
                    Section {
                        HStack {
                            Spacer()
                            VStack {
                                Image(systemName: "magnifyingglass")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .padding(8)
                                    .background(.blue)
                                    .clipShape(.rect(cornerRadius: 10))
                                Text(
                                    "All your in progress lessons in one place. Browse, search and start working."
                                )
                                .multilineTextAlignment(.center)
                                .font(.subheadline)
                            }
                            Spacer()
                        }
                    }
                    if lessonsForYou.count > 0 {
                        Section("Lessons in progress") {
                            ForEach(
                                lessonsForYou,
                                id: \.self
                            ) {
                                lesson in
                                NavigationLink {
                                    ProjectList(lesson: lesson)
                                } label: {
                                    Label(
                                        "Days \(lesson.firstDay)-\(lesson.lastDay): \(lesson.title)",
                                        systemImage: "circle.dotted"
                                    )
                                }
                            }
                        }
                    } else {
                        Text("No lessons in progress...")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Text("Searching in \(lessonsForYou.count) lessons...")
                    if filteredLessons.count > 0 {
                        ForEach(
                            lessonsForYou,
                            id: \.self
                        ) {
                            lesson in
                            NavigationLink {
                                ProjectList(lesson: lesson)
                            } label: {
                                Label(
                                    "Days \(lesson.firstDay)-\(lesson.lastDay): \(lesson.title)",
                                    systemImage: "circle.dotted"
                                )
                            }
                        }
                    } else {
                        Text("No results for \"\(searchText)\"")
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("For You")
        }
    }
}

#Preview {
    ForYouView()
}
