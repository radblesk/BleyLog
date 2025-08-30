//
//  WordScramble.swift
//  BleyLog
//
//  Created by Radoslav Bley on 26/08/2025.
//

import SwiftData
import SwiftUI

struct WordScramble: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \WSUsedWord.createdAt, order: .reverse) var words: [WSUsedWord]

    @AppStorage("currentWord") private var currentWord: String = ""
    @AppStorage("playerName") private var playerName: String = "Anonymous"
    @AppStorage("playerScore") private var playerScore: Int = 0

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
            Section(playerName.trimmingCharacters(in: .whitespacesAndNewlines)) {
                Text("Current score: \(playerScore)")
            }
            Section {
                TextField("Enter a word", text: $newWord)
                    .focused($focused)
                    .autocorrectionDisabled(true)
                    #if !os(macOS)
                        .textInputAutocapitalization(.never)
                    #endif

            }

            Section("\(words.count) words") {
                ForEach(words) { word in
                    HStack {
                        Image(systemName: "\(word.text.count).circle")
                        Text(word.text)
                    }
                }
            }

        }
        #if os(iOS)
            .scrollDismissesKeyboard(.interactively)
        #endif
        .navigationTitle(currentWord)
        .onSubmit(addNewWord)
        .onAppear(perform: startGame)
        .alert(errorTitle, isPresented: $showingError) {
        } message: {
            Text(errorMessage)
        }
        .toolbar {
            #if os(iOS)
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink("Data Migration") {
                        MigrationView()
                    }
                }
            #endif
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
            LeaderboardView()
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $settingPlayer) {
            SetPlayer(playerName: $playerName)
                .presentationDetents([.height(160)])
        }
    }

    // MARK: - Methods

    // Adds a new word into an array
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        /// Checks if answer property has at least one character
        guard answer.count > 2 else {
            wordError(title: "Word too short", message: "Words have to be longer than 2 characters")
            return
        }

        guard answer != currentWord.lowercased() else {
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
                message: "You can't spell that word from '\(currentWord)'"
            )
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up")
            return
        }

        do {
            let newWord = WSUsedWord(text: answer, createdAt: Date.now)
            modelContext.insert(newWord)

            try modelContext.save()
        } catch {
            print("Failed to save new word: \(error.localizedDescription)")
        }

        playerScore = playerScore + score(for: answer)

        /// Empties text field input
        newWord = ""
        focused = true
    }

    // Start a new game
    func startGame() {
        if words.isEmpty {
            /// Resets textfield
            newWord = ""
            focused = true
            if playerName == "Anonymous" {
                settingPlayer = true
            }

            /// Finds URL for start.txt
            if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
                /// Converts file content into String
                if let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8) {
                    /// Breaks string on line breaks to create an array of words from inside the file
                    let allWords = startWords.components(separatedBy: "\n")
                    /// Pick a random word from an array
                    currentWord = allWords.randomElement() ?? "silkworm"
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
        do {
            if !words.isEmpty {
                let wordsArray = words.map(\.text)
                /// Save to leaderboard
                let player = WSPlayer(
                    name: playerName.trimmingCharacters(in: .whitespacesAndNewlines),
                    word: currentWord,
                    usedWords: wordsArray,
                    score: playerScore,
                    date: Date.now
                )

                modelContext.insert(player)

                try modelContext.delete(model: WSUsedWord.self)
                playerScore = 0
                newWord = ""
                focused = true
            }

            /// Finds URL for start.txt
            if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
                /// Converts file content into String
                if let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8) {
                    /// Breaks string on line breaks to create an array of words from inside the file
                    let allWords = startWords.components(separatedBy: "\n")
                    /// Pick a random word from an array
                    currentWord = allWords.randomElement() ?? "silkworm"
                    return
                }
            }
        } catch {
            print("Failed to delete used words array: \(error.localizedDescription)")
        }
    }

    // Checks whether inserted word is already contained in the array
    func isOriginal(word: String) -> Bool {
        !words.contains(where: { $0.text == word })
    }

    // Checks whether letters used in input word are included in root word
    func isPossible(word: String) -> Bool {
        var tempWord = currentWord

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
    #elseif os(watchOS)
        func isReal(word: String) -> Bool {
            if let existingWords = Bundle.main.url(forResource: "words_alpha", withExtension: "txt") {
                if let words = try? String(contentsOf: existingWords, encoding: .utf8) {
                    let allWords = words.components(separatedBy: "\n").map {
                        $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    }
                    return allWords.contains(word)
                }
            }
            return false
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
