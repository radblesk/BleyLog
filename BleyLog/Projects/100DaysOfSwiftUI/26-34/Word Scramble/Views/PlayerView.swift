//
//  PlayerView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 30/08/2025.
//

import SwiftData
import SwiftUI

struct PlayerView: View {
    var player: WSPlayer
    var top: String
    @State private var showing: Bool = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(player.score) points")
                    .font(.title3.bold())

                HStack(spacing: 4) {
                    Text("\(player.wordsCount) words")
                        .font(.subheadline)
                        .onTapGesture {
                            showing.toggle()
                        }
                    
                    Image(systemName: "chevron.down")
                        .font(.footnote)
                }

                Text(player.word)
                    .font(.footnote)

            }
            Spacer()
            VStack(alignment: .trailing) {

                Text(
                    "\(player.date.formatted(.dateTime.day().month().year().hour().minute()))"
                )
                .font(.caption)
                Spacer()
                HStack {
                    if !top.isEmpty && top == player.name {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(.yellow)
                    }
                    Text(player.name)
                        .font(.headline)
                }

            }.padding(.vertical)
        }
        .sheet(isPresented: $showing) {
            List(player.usedWords.sorted(), id: \.self) { word in
                HStack {
                    Image(systemName: "\(word.count).circle")
                    Text(word)
                }
            }
            .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WSPlayer.self, configurations: config)
        let examplePlayer = WSPlayer(
            name: "Radoslav",
            word: "word",
            usedWords: ["word"],
            score: 534,
            date: Date()
        )

        return NavigationStack {
            PlayerView(player: examplePlayer, top: "Radoslav")
                .modelContainer(container)
        }
    } catch {
        return Text("Failed to create example player: \(error.localizedDescription)")
    }
}
