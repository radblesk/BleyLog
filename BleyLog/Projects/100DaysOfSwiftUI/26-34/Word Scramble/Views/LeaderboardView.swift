//
//  LeaderboardView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 30/08/2025.
//

import SwiftData
import SwiftUI

struct LeaderboardView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [
        SortDescriptor(\WSPlayer.score, order: .reverse),
        SortDescriptor(\WSPlayer.date, order: .reverse),
    ]) var scores: [WSPlayer]

    var body: some View {
        let topPlayer = scores.first.map(\.name) ?? ""
        NavigationStack {
            List {
                Section("\(scores.count) entries") {
                    ForEach(scores) { score in
                        PlayerView(player: score, top: topPlayer)
                    }
                    .onDelete(perform: deleteItem)
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Leaderboard")
            #if os(iOS)
                .toolbar {
                    EditButton()
                }
            #endif
        }
    }

    func deleteItem(at offsets: IndexSet) {
        for offset in offsets {
            let score = scores[offset]
            modelContext.delete(score)
        }
    }
}
