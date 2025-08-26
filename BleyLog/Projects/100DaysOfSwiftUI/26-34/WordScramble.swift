//
//  WordScramble.swift
//  BleyLog
//
//  Created by Radoslav Bley on 26/08/2025.
//

import SwiftUI

struct WordScramble: View {
    // MARK: States
    /// Words
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""

    /// Score
    @State private var score: Int = 0

    /// Errors
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Current score: \(score)")
                }
                Section {
                    TextField("Enter a word", text: $newWord)
                        .autocorrectionDisabled(true)
                        #if !os(macOS)
                            .textInputAutocapitalization(.never)
                        #endif

                }

                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                ToolbarItem {
                    Button("Restart") {
                        startGame()
                    }
                }
            }
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
            wordError(
                title: "Word too short",
                message: "Words have to be longer than 2 characters"
            )
            return
        }

        guard answer != rootWord.lowercased() else {
            wordError(
                title: "Word matches root word",
                message: "You can't use the root word again"
            )
            return
        }

        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be original")
            return
        }

        guard isPossible(word: answer) else {
            wordError(
                title: "Word is not possible",
                message: "You can't spell that word from '\(rootWord)'"
            )
            return
        }

        #if os(iOS)
            guard isReal(word: answer) else {
                wordError(
                    title: "Word not recognized",
                    message: "You can't just make them up"
                )
                return
            }
        #endif

        withAnimation {
            /// Inserts answer at the start of an array
            usedWords.insert(answer, at: 0)
        }

        score = score + score(for: answer)

        /// Empties text field input
        newWord = ""
    }

    // Start a new game
    func startGame() {
        /// Resets score
        score = 0

        /// Removes usedWords array
        usedWords.removeAll()

        /// Resets textfield
        newWord = ""

        /// Finds URL for start.txt
        if let startWordsURL = Bundle.main.url(
            forResource: "start",
            withExtension: "txt"
        ) {
            /// Converts file content into String
            if let startWords = try? String(
                contentsOf: startWordsURL,
                encoding: .utf8
            ) {
                /// Breaks string on line breaks to create an array of words from inside the file
                let allWords = startWords.components(separatedBy: "\n")
                /// Pick a random word from an array
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }

        /// Crash the app if file could not be located or loaded
        fatalError("Could not load start.txt from bundle.")
    }

    // Checks whether inserted word is already contained in the array
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }

    // Checks whether letters used in input word are included in root word
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord

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
    WordScramble()
}
