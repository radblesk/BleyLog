//
//  Edutainment.swift
//  BleyLog
//
//  Created by Radoslav Bley on 26/08/2025.
//

import SwiftUI

struct Edutainment: View {
    // Enums
    /// Options for number of questions
    enum NumberOfQuestions: Int, CaseIterable {
        case five = 5
        case ten = 10
        case twenty = 20
    }

    // States
    /// User selectable states
    @State private var upTo: Int = 5
    @State private var numberOfQuestions: NumberOfQuestions = .five

    /// Data holding states
    @State private var generatedQuestions: [String] = []

    /// Button states
    @State private var check = false

    // MARK: - Main View
    var body: some View {
        NavigationStack {
            List {
                Section("Multiplication table") {
                    Stepper(
                        "Multiplications up to \(upTo)",
                        value: $upTo,
                        in: 2...12
                    )
                }

                Section("Number of questions") {
                    Picker(
                        "Select number of questions",
                        selection: $numberOfQuestions
                    ) {
                        ForEach(NumberOfQuestions.allCases, id: \.rawValue) {
                            option in
                            Text("\(option.rawValue)")
                                .tag(option)
                        }
                    }
                }

                ForEach(generatedQuestions, id: \.self) { question in
                    Question(question: question, check: $check)
                }

                if generatedQuestions.isEmpty {
                    Button("Start") {
                        withAnimation {
                            generateQuestions()
                        }
                    }
                } else {
                    Button("Check answers") {
                        withAnimation {
                            check = true
                        }
                    }
                }
            }
            #if os(iOS)
                .scrollDismissesKeyboard(.interactively)
            #endif
            .navigationTitle("Edutainment")
            .toolbar {
                if check {
                    Button("Restart") {
                        withAnimation {
                            generateQuestions()
                        }
                    }
                }
            }
        }
    }

    // MARK: - Main Methods
    private func generateQuestions() {
        check = false
        var table: [String] = []

        for number in 1...upTo {
            for number2 in 1...upTo {
                table.append("\(number) x \(number2) =")
            }
        }

        generatedQuestions = Array(
            table.shuffled().prefix(numberOfQuestions.rawValue)
        )
    }
}

// MARK: - Question View
struct Question: View {
    // Passed properties
    var question: String

    // Binding Properties
    @Binding var check: Bool

    // States
    @State private var answer = ""
    @State private var color: Color = .primary

    var body: some View {
        HStack {
            Text(question)
            TextField("Answer", text: $answer)
                #if os(iOS)
                    .keyboardType(.decimalPad)
                #endif
                .foregroundStyle(color)
                .onChange(of: check) {
                    if check {
                        evaluation()
                    } else {
                        answer = ""
                        color = .primary
                    }
                }
        }
    }

    // MARK: - Question Methods
    func getCorrectAnswer() -> String {
        let parts = question.split(separator: " ")
        let number1 = Int(parts[0])!
        let number2 = Int(parts[2])!
        return "\(number1 * number2)"
    }

    func isCorrect() -> Bool {
        answer == getCorrectAnswer()
    }

    func evaluation() {
        if check {
            if answer.isEmpty {
                check.toggle()
            } else {
                if isCorrect() {
                    answer = "\(answer) is correct!"
                    color = .green
                } else {
                    answer = "\(answer) is wrong!"
                    color = .red
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    Edutainment()
}
