//
//  LessonsListView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 28/08/2025.
//

import SwiftUI

struct LessonsListView: View {
    @Environment(ModelData.self) var modelData

    @State private var isPresented = false
    @State private var showMore = false

    var body: some View {
        @Bindable var modelData = modelData

        List(modelData.courses(in: modelData.selectedLanguage), selection: $modelData.selectedLesson) { course in
            Section(course.title) {
                ForEach(modelData.lessons(in: course, status: .started)) { lesson in
                    NavigationLink(value: lesson) {
                        LessonListRow(lesson: lesson)
                    }
                }

                if showMore {
                    ForEach(modelData.lessons(in: course, status: .notStarted)) { lesson in
                        NavigationLink(value: lesson) {
                            LessonListRow(lesson: lesson)
                        }
                        .disabled(true)
                        .selectionDisabled(true)
                    }
                }

                Button(showMore ? "Show fewer" : "Show more") {
                    withAnimation { showMore.toggle() }
                }
            }
        }
        .navigationTitle("Courses")
        .containerBackground(
            RadialGradient(colors: [Color.accentColor, .black], center: .bottom, startRadius: -200, endRadius: 400),
            for: .navigation
        )
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button("Language", systemImage: "line.3.horizontal.decrease") {
                    isPresented.toggle()
                }
            }

        }
        .sheet(isPresented: $isPresented) {
            Picker("Language", selection: $modelData.selectedLanguage) {
                ForEach(modelData.languages) { language in
                    Text(language.title)
                        .tag(language)
                }
            }
        }
    }
}

#Preview {
    let modelData = ModelData()

    NavigationStack {
        LessonsListView()
            .environment(modelData)
    }
}
