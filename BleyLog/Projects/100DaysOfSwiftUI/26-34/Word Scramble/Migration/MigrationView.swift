//
//  MigrationView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 31/08/2025.
//

import SwiftData
import SwiftUI

struct MigrationView: View {
    @Environment(\.modelContext) var modelContext
    @State private var scores: [PlayerScore] = []
    @State private var progressMessage: String = ""
    @State private var dataLoaded: Bool = false

    var body: some View {
        List {
            Section("Manage data") {
                Text(progressMessage)

                Button(scores.isEmpty ? "Find data" : "Migrate data") {
                    if scores.isEmpty {
                        findData()
                    } else {
                        migrateData()
                    }
                }
            }

            if dataLoaded {
                Section("Found data") {
                    ForEach(scores) { score in
                        VStack {
                            Text(score.name)
                            Text(score.date.formatted())
                            Text("\(score.id)")
                            Text("\(score.score)")
                            Text("\(score.scoredWords)")
                            Text(score.word)

                        }
                    }
                }
            } else {
                Text("No data")
            }
        }
        .navigationTitle("Data migration")
//        #if os(iOS)
//            ToolbarItem(placement: .bottomBar) {
//                NavigationLink("Migration") {
//                    MigrationView()
//                }
//            }
//        #endif

    }
    func findData() {
        progressMessage = "Looking for saved scores..."
        if let savedScores = UserDefaults.standard.data(forKey: "Leaderboard") {
            progressMessage = "Data found. Decoding to previous model format..."
            if let decodedScores = try? JSONDecoder().decode([PlayerScore].self, from: savedScores) {
                progressMessage = "Data decoded. Saving to temporary storage..."
                scores = decodedScores
                dataLoaded = true
                progressMessage = "Data loaded."
            }
        } else {
            progressMessage = "No data found."
            scores = []
            dataLoaded = false
        }
    }

    func migrateData() {
        progressMessage = "Starting migration process..."

        for score in scores {
            progressMessage = "Migrating score: \(score.date.formatted())"
            let name = "radblesk"
            let scoreNumber = score.score
            let date = score.date
            let word = score.word

            let migratedModel = WSPlayer(name: name, word: word, usedWords: [], score: scoreNumber, date: date)

            modelContext.insert(migratedModel)
        }

        progressMessage = "Migration complete. Enjoy!"
    }
}

#Preview {
    MigrationView()
}
