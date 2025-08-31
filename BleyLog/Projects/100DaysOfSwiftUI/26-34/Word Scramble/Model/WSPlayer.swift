//
//  WSPlayer.swift
//  BleyLog
//
//  Created by Radoslav Bley on 30/08/2025.
//

import Foundation
import SwiftData

@Model
class WSPlayer {
    var name: String = "Unknown"
    var word: String = "Unknown"
    var usedWords: [String] = [String]()
    var wordsCount: Int {
        return usedWords.count
    }
    var score: Int = 0
    var date: Date = Date.now

    init(name: String, word: String, usedWords: [String], score: Int, date: Date) {
        self.name = name
        self.word = word
        self.usedWords = usedWords
        self.score = score
        self.date = date
    }
}
