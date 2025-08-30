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
                    #if os(iOS)
                        .font(.title3.bold())
                    #else
                        .font(.system(size: 16, weight: .bold))
                    #endif

                HStack(spacing: 2) {
                    Text("^[\(player.wordsCount) word](inflect: true)")
                        #if os(iOS)
                            .font(.subheadline)
                        #else
                            .font(.system(size: 12))
                        #endif
                        .onTapGesture {
                            showing.toggle()
                        }

                    Image(systemName: "chevron.down")
                        #if os(iOS)
                            .font(.footnote)
                        #else
                            .font(.system(size: 10))
                        #endif
                }

                Text(player.word)
                    #if os(iOS)
                        .font(.footnote)
                    #else
                        .font(.system(size: 10))
                    #endif

            }
            Spacer()
            VStack(alignment: .trailing) {

                Text(
                    "\(player.date.formatted(.dateTime.day().month().year().hour().minute()))"
                )
                .multilineTextAlignment(.trailing)
                #if os(iOS)
                    .font(.caption)
                #else
                    .font(.system(size: 10))
                #endif
                Spacer()
                HStack {
                    if !top.isEmpty && top == player.name {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(.yellow)
                            #if os(watchOS)
                                .font(.system(size: 10))
                            #endif
                    }
                    Text(player.name)
                        #if os(iOS)
                            .font(.headline)
                        #else
                            .font(.system(size: 10, weight: .semibold))
                        #endif
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
            usedWords: ["word", "work"],
            score: 534,
            date: Date()
        )

        return NavigationStack {
            List {
                PlayerView(player: examplePlayer, top: "Radoslav")
                    .modelContainer(container)
            }
        }
    } catch {
        return Text("Failed to create example player: \(error.localizedDescription)")
    }
}
