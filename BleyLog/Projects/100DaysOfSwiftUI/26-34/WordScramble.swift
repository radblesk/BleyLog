//
//  WordScramble.swift
//  BleyLog
//
//  Created by Radoslav Bley on 26/08/2025.
//

import SwiftUI

// MARK: - Player Model
struct PlayerScore: Identifiable, Codable {
    var id = UUID()
    let name: String
    let score: Int
    let scoredWords: Int
    let date: Date
    let word: String
}

// MARK: - Word Model
struct UsedWord: Identifiable, Codable {
    var id = UUID()
    let text: String
}

// MARK: - GameSave Model
@Observable
class GameSave {

    var playerName: String {
        didSet {
            UserDefaults.standard.set(playerName, forKey: "CurrentPlayer")
        }
    }

    var currentWord: String {
        didSet {
            UserDefaults.standard.set(currentWord, forKey: "CurrentWord")
        }
    }

    var currentScore: Int {
        didSet {
            UserDefaults.standard.set(currentScore, forKey: "CurrentScore")
        }
    }

    var usedWords = [UsedWord]() {
        didSet {
            if let encodedWords = try? JSONEncoder().encode(usedWords) {
                UserDefaults.standard.set(encodedWords, forKey: "UsedWords")
            }
        }
    }

    init() {
        if let savedWords = UserDefaults.standard.data(forKey: "UsedWords") {
            if let decodedWords = try? JSONDecoder().decode([UsedWord].self, from: savedWords) {
                usedWords = decodedWords
            }
        } else {
            usedWords = []
        }
        playerName = UserDefaults.standard.string(forKey: "CurrentPlayer") ?? "Anonymous"
        currentWord = UserDefaults.standard.string(forKey: "CurrentWord") ?? ""
        currentScore = UserDefaults.standard.integer(forKey: "CurrentScore")
    }
}

// MARK: - Leaderboard Model
@Observable
class Leaderboard {
    var scores = [PlayerScore]() {
        didSet {
            if let encodedScores = try? JSONEncoder().encode(scores) {
                UserDefaults.standard.set(encodedScores, forKey: "Leaderboard")
            }
        }
    }

    init() {
        if let savedScores = UserDefaults.standard.data(forKey: "Leaderboard") {
            if let decodedScores = try? JSONDecoder().decode([PlayerScore].self, from: savedScores)
            {
                scores = decodedScores
            }
        } else {
            scores = []
        }
    }
}

// MARK: - Main View
struct WordScramble: View {
    // MARK: Models
    @State private var gamesave = GameSave()
    @State private var leaderboard = Leaderboard()

    // MARK: States
    /// Words
    @State private var newWord = ""

    /// Errors
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false

    /// Leaderboard
    @State private var showing = false

    /// Set player
    @State private var settingPlayer = false

    /// Focus state
    @FocusState private var focused: Bool

    var placement: ToolbarItemPlacement {
        #if os(watchOS)
            .bottomBar
        #else
            .automatic
        #endif
    }

    var body: some View {
        List {
            Section(gamesave.playerName) {
                Text("Current score: \(gamesave.currentScore)")
            }
            Section {
                TextField("Enter a word", text: $newWord)
                    .focused($focused)
                    .autocorrectionDisabled(true)
                    #if !os(macOS)
                        .textInputAutocapitalization(.never)
                    #endif

            }

            if !gamesave.usedWords.isEmpty {

                Section("\(gamesave.usedWords.count) words") {
                    ForEach(gamesave.usedWords.reversed()) { word in
                        HStack {
                            Image(systemName: "\(word.text.count).circle")
                            Text(word.text)
                        }
                    }
                }
            }
        }
        #if os(iOS)
            .scrollDismissesKeyboard(.interactively)
        #endif
        .navigationTitle(gamesave.currentWord)
        .onSubmit(addNewWord)
        .onAppear(perform: startGame)
        .alert(errorTitle, isPresented: $showingError) {
        } message: {
            Text(errorMessage)
        }
        .toolbar {
            ToolbarItemGroup(placement: placement) {
                Button("Leaderboard", systemImage: "laurel.leading.laurel.trailing") {
                    showing = true
                }
                Button("Change Player", systemImage: "person") {
                    settingPlayer = true
                }
                Button("Restart", systemImage: "arrow.clockwise") {
                    resetGame()
                }
            }
        }
        .sheet(isPresented: $showing) {
            LeaderboardView(leaderboard: leaderboard)
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $settingPlayer) {
            SetPlayer(gamesave: gamesave)
                .presentationDetents([.height(160)])
        }
    }

    // MARK: - Leaderboard view
    struct LeaderboardView: View {
        var leaderboard: Leaderboard

        var sortedScores: [PlayerScore] {
            return leaderboard.scores.sorted { $0.score > $1.score }
        }

        var body: some View {
            NavigationStack {
                let topScore = leaderboard.scores.sorted { $0.score > $1.score }.first
                List {
                    if leaderboard.scores.isEmpty {
                        Text("No scores yet. Play and try to beat the leaderboard!")
                    } else {
                        ForEach(sortedScores) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(item.score) points")
                                        .font(.title3.bold())

                                    Text("\(item.scoredWords) words")
                                        .font(.subheadline)

                                    Text(item.word)
                                        .font(.footnote)

                                }
                                Spacer()
                                VStack(alignment: .trailing) {

                                    Text(
                                        "\(item.date.formatted(.dateTime.day().month().year().hour().minute()))"
                                    )
                                    .font(.caption)
                                    Spacer()
                                    HStack {
                                        if let topScore {
                                            if topScore.name == item.name {
                                                Image(systemName: "crown.fill")
                                                    .foregroundStyle(.yellow)
                                            }
                                        }
                                        Text(item.name)
                                            .font(.headline)
                                    }

                                }.padding(.vertical)
                            }

                        }
                        .onDelete(perform: remove)
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

        func remove(at offsets: IndexSet) {
            let itemsToDelete = offsets.map { sortedScores[$0] }

            leaderboard.scores.removeAll { score in
                itemsToDelete.contains(where: { $0.id == score.id })
            }
        }
    }

    // MARK: - Set player view
    struct SetPlayer: View {
        @Environment(\.dismiss) var dismiss
        var gamesave: GameSave

        @State private var playerName: String = ""
        @State private var date = Date()

        var body: some View {
            NavigationStack {
                Form {
                    TextField("Name", text: $playerName)
                        .autocorrectionDisabled()
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Set a new player")
                #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    Button("Save") {
                        savePlayer()
                    }
                }
                .onAppear(perform: retrievePlayer)
                .onSubmit(savePlayer)
            }
        }

        func savePlayer() {
            gamesave.playerName = playerName
            dismiss()
        }

        func retrievePlayer() {
            playerName = gamesave.playerName
        }
    }

    // MARK: - Methods

    // Adds a new word into an array
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let newItem = UsedWord(text: answer)

        /// Checks if answer property has at least one character
        guard answer.count > 2 else {
            wordError(title: "Word too short", message: "Words have to be longer than 2 characters")
            return
        }

        guard answer != gamesave.currentWord.lowercased() else {
            wordError(title: "Word matches root word", message: "You can't use the root word again")
            return
        }

        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be original")
            return
        }

        guard isPossible(word: answer) else {
            wordError(
                title: "Word is not possible",
                message: "You can't spell that word from '\(gamesave.currentWord)'"
            )
            return
        }

        #if os(iOS)
            guard isReal(word: answer) else {
                wordError(title: "Word not recognized", message: "You can't just make them up")
                return
            }
        #endif

        withAnimation {
            /// Inserts answer at the start of an array
            gamesave.usedWords.append(newItem)
        }
        gamesave.currentScore = gamesave.currentScore + score(for: answer)

        /// Empties text field input
        newWord = ""
        focused = true
    }

    // Start a new game
    func startGame() {
        if gamesave.usedWords.isEmpty {
            /// Resets textfield
            newWord = ""
            focused = true
            if gamesave.playerName == "Anonymous" {
                settingPlayer = true
            }

            /// Finds URL for start.txt
            if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
                /// Converts file content into String
                if let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8) {
                    /// Breaks string on line breaks to create an array of words from inside the file
                    let allWords = startWords.components(separatedBy: "\n")
                    /// Pick a random word from an array
                    gamesave.currentWord = allWords.randomElement() ?? "silkworm"
                    return
                }
            }

            /// Crash the app if file could not be located or loaded
            fatalError("Could not load start.txt from bundle.")
        } else {
            return
        }
    }

    func resetGame() {
        if !gamesave.usedWords.isEmpty {
            /// Save to leaderboard
            let score = PlayerScore(
                name: gamesave.playerName,
                score: gamesave.currentScore,
                scoredWords: gamesave.usedWords.count,
                date: Date(),
                word: gamesave.currentWord,
            )
            leaderboard.scores.append(score)
        }

        gamesave.currentScore = 0
        gamesave.usedWords.removeAll()
        newWord = ""
        focused = true

        /// Finds URL for start.txt
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            /// Converts file content into String
            if let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8) {
                /// Breaks string on line breaks to create an array of words from inside the file
                let allWords = startWords.components(separatedBy: "\n")
                /// Pick a random word from an array
                gamesave.currentWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
    }

    // Checks whether inserted word is already contained in the array
    func isOriginal(word: String) -> Bool {
        !gamesave.usedWords.contains(where: { $0.text == word })
    }

    // Checks whether letters used in input word are included in root word
    func isPossible(word: String) -> Bool {
        var tempWord = gamesave.currentWord

        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }

        return true
    }

    #if os(iOS)
        // Scans strings for misspelled words
        func isReal(word: String) -> Bool {
            let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf16.count)
            let misspelledRange = checker.rangeOfMisspelledWord(
                in: word,
                range: range,
                startingAt: 0,
                wrap: false,
                language: "en"
            )
            return misspelledRange.location == NSNotFound
        }
    #endif

    // Error method
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }

    // Score calculation
    func score(for word: String) -> Int {
        let wordScore = word.count
        return wordScore
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        WordScramble()
    }
}
