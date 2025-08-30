////
////  Untitled.swift
////  BleyLog
////
////  Created by Radoslav Bley on 30/08/2025.
////
//
//// MARK: - Player Model
//struct PlayerScore: Identifiable, Codable {
//    var id = UUID()
//    let name: String
//    let score: Int
//    let scoredWords: Int
//    let date: Date
//    let word: String
//}
//
//// MARK: - Word Model
//struct UsedWord: Identifiable, Codable {
//    var id = UUID()
//    let text: String
//}
//
//// MARK: - GameSave Model
//@Observable
//class GameSave {
//    
//    var playerName: String {
//        didSet {
//            UserDefaults.standard.set(playerName, forKey: "CurrentPlayer")
//        }
//    }
//    
//    var currentWord: String {
//        didSet {
//            UserDefaults.standard.set(currentWord, forKey: "CurrentWord")
//        }
//    }
//    
//    var currentScore: Int {
//        didSet {
//            UserDefaults.standard.set(currentScore, forKey: "CurrentScore")
//        }
//    }
//    
//    var usedWords = [UsedWord]() {
//        didSet {
//            if let encodedWords = try? JSONEncoder().encode(usedWords) {
//                UserDefaults.standard.set(encodedWords, forKey: "UsedWords")
//            }
//        }
//    }
//    
//    init() {
//        if let savedWords = UserDefaults.standard.data(forKey: "UsedWords") {
//            if let decodedWords = try? JSONDecoder().decode([UsedWord].self, from: savedWords) {
//                usedWords = decodedWords
//            }
//        } else {
//            usedWords = []
//        }
//        playerName = UserDefaults.standard.string(forKey: "CurrentPlayer") ?? "Anonymous"
//        currentWord = UserDefaults.standard.string(forKey: "CurrentWord") ?? ""
//        currentScore = UserDefaults.standard.integer(forKey: "CurrentScore")
//    }
//}
//
//// MARK: - Leaderboard Model
//@Observable
//class Leaderboard {
//    var scores = [PlayerScore]() {
//        didSet {
//            if let encodedScores = try? JSONEncoder().encode(scores) {
//                UserDefaults.standard.set(encodedScores, forKey: "Leaderboard")
//            }
//        }
//    }
//    
//    init() {
//        if let savedScores = UserDefaults.standard.data(forKey: "Leaderboard") {
//            if let decodedScores = try? JSONDecoder().decode([PlayerScore].self, from: savedScores) {
//                scores = decodedScores
//            }
//        } else {
//            scores = []
//        }
//    }
//}
