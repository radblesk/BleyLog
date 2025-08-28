//
//  RockPaperScissors.swift
//  BleyLog
//
//  Created by Radoslav Bley on 20/08/2025.
//

import SwiftUI

struct RockPaperScissors: View {
    // States
    @State private var moves = ["Rock", "Paper", "Scissors"]
    @State private var gameStarted = false
    @State private var computerMove: String = ""
    @State private var playerMove: String = ""
    @State private var playerWon = Bool.random()
    @State private var score: Int = 0
    @State private var tries: Int = 0
    @State private var isGameOver = false

    var body: some View {
        VStack(spacing: 20) {
            #if !os(watchOS)
                Text(
                    """
                    Try to beat me. 
                    Choose wisely!
                    """
                )
            #endif
            #if os(watchOS)
                Spacer()
            #endif
            VStack {
                ForEach(moves, id: \.self) { move in
                    Button(move) {
                        playersMove(move)
                    }
                    #if os(watchOS)
                        .tint(
                            move == playerMove && move == computerMove
                                ? .green
                                : gameStarted
                                    && move == computerMove
                                    && computerMove != playerMove
                                    ? .green
                                    : move == playerMove
                                        && move != computerMove
                                        ? .red : .none
                        )
                    #else
                        .tint(
                            move == playerMove && move == computerMove
                                ? .green
                                : gameStarted
                                    && move == computerMove
                                    && computerMove != playerMove
                                    ? .green
                                    : move == playerMove
                                        && move != computerMove
                                        ? .red : .none
                        )
                    #endif
                    .buttonStyle(.borderedProminent)
                    .controlSize(.extraLarge)
                }
            }
        }
        .navigationTitle("Rock, Paper, Scissors")
        #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
        .alert(
            score < 5
                ? "Game Over! Poor performance, if you ask me."
                : score > 4 && score < 10
                    ? "Not great, not terrible."
                    : "You did it you crazy son of a bitch, you did it!",
            isPresented: $isGameOver
        ) {
            Button("Play again") { resetGame() }
        } message: {
            Text("Your score is \(score) / \(tries)")
        }
    }

    private func playersMove(_ move: String) {
        computerMove = moves.randomElement()!
        playerMove = move
        if !gameStarted {
            gameStarted = true
        }
        if tries < 9 {
            if move == computerMove {
                playerWon = true
                score = min(10, score + 1)
                tries = min(10, tries + 1)
            } else {
                playerWon = false
                score = max(0, score - 1)
                tries = min(10, tries + 1)
            }
        } else {
            if move == computerMove {
                playerWon = true
                score = min(10, score + 1)
                tries = min(10, tries + 1)
            } else {
                playerWon = false
                score = max(0, score - 1)
                tries = min(10, tries + 1)
            }
            isGameOver = true
        }

    }

    private func resetGame() {
        score = 0
        tries = 0
        isGameOver = false
        gameStarted = false
    }
}

#Preview {
    NavigationStack {
        RockPaperScissors()
    }
}
