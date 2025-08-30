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
    var name: String
    var word: String
    var usedWords: [String]
    var wordsCount: Int {
        return usedWords.count
    }
    var score: Int
    var date: Date

    init(name: String, word: String, usedWords: [String], score: Int, date: Date) {
        self.name = name
        self.word = word
        self.usedWords = usedWords
        self.score = score
        self.date = date
    }
}
