//
//  WeSplit.swift
//  HWS
//
//  Created by Radoslav Bley on 10/08/2025.
//

import Foundation

struct CodeSnippets {
    static let weSplit = #"""
        //
        //  WeSplit.swift
        //  HWS
        //
        //  Created by Radoslav Bley on 08/07/2025.
        //
        
        import HighlightSwift
        import SwiftUI
        
        struct WeSplit: View {
        @State private var checkAmount = 0.0
        @State private var numberOfPeople = 0
        @State private var tipPercentage = 20
        @FocusState private var amountIsFocused: Bool
        @State private var inspectorShown = false
        
        let tipPercentages = [10, 15, 20, 25, 0]
        
        var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
        }
        
        var totalCheckAmount: Double {
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        
        return grandTotal
        }
        
        var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(
                        "Amount",
                        value: $checkAmount,
                        format: .currency(
                            code: Locale.current.currency?.identifier ?? "EUR"
                        )
                    )
                    #if os(iOS)
                        .keyboardType(.decimalPad)
                    #endif
                    .focused($amountIsFocused)
        
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                    #if os(iOS)
                        .pickerStyle(.navigationLink)
                    #endif
                }
        
                Section("How much do you want to tip?") {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                }
        
                Section("Grand Total") {
                    Text(
                        totalCheckAmount,
                        format:
                            .currency(
                                code: Locale.current.currency?.identifier
                                    ?? "EUR"
                            )
                    )
                }
        
                Section("Amount per person") {
                    Text(
                        totalPerPerson,
                        format: .currency(
                            code: Locale.current.currency?.identifier ?? "EUR"
                        )
                    )
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                Button {
                    inspectorShown = true
                } label: {
                    Label("Inspector", systemImage: "info.circle.fill")
                }
                .buttonStyle(.borderedProminent)
                if amountIsFocused {
                    Button("Done", systemImage: "checkmark") {
                        amountIsFocused = false
                    }
                }
            }
            .inspector(isPresented: $inspectorShown) {
                ScrollView {
                    CodeText(CodeSnippets.weSplit)
                        .highlightLanguage(.swift)
                        .codeTextColors(.theme(.xcode))
                }
                .padding()
                .font(.callout)
            }
        }
        }
        }
        
        #Preview {
        WeSplit()
        }

        """#

    static let tempConvert = #"""
        //
        //  TempConvert.swift
        //  HWS
        //
        //  Created by Radoslav Bley on 21/07/2025.
        //
        
        import HighlightSwift
        import SwiftUI
        
        struct TempConvert: View {
        @State private var temperature = 0.0
        @FocusState private var temperatureFieldIsFocused: Bool
        
        var units = ["Celsius", "Fahrenheit", "Kelvin"]
        @State private var inputUnit = "Celsius"
        @State private var outputUnit = "Fahrenheit"
        
        var convertedTemperature: Double {
        let inputValue = temperature
        let inputUnit = inputUnit
        let outputUnit = outputUnit
        var baseValue: Double = 0.0
        
        if inputUnit == "Celsius" {
            baseValue = inputValue
        } else if inputUnit == "Fahrenheit" {
            baseValue = (inputValue - 32) * 5 / 9
        } else if inputUnit == "Kelvin" {
            baseValue = inputValue - 273.15
        }
        
        var convertedValue: Double {
            if outputUnit == "Celsius" {
                return baseValue
            } else if outputUnit == "Fahrenheit" {
                return baseValue * 9 / 5 + 32
            } else if outputUnit == "Kelvin" {
                return baseValue + 273.15
            }
            return 0.0
        }
        
        return convertedValue
        }
        
        @State private var inspectorShown = false
        
        var body: some View {
        NavigationStack {
            Form {
                Section("Insert Temperature") {
                    TextField(
                        "Enter temperature",
                        value: $temperature,
                        format: .number
                    )
                    #if os(iOS)
                        .keyboardType(.decimalPad)
                    #endif
                    .focused($temperatureFieldIsFocused)
                }
        
                Section(
                    header: Text("Units"),
                    footer: Text("Select units to convert from and to.")
                ) {
                    Picker("Input Unit", selection: $inputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
        
                    Picker("Output Unit", selection: $outputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                }
        
                Section("Converted Temperature") {
                    Text(
                        "\(convertedTemperature, format: .number) °\(outputUnit.first?.uppercased() ?? "")"
                    )
                    .contentTransition(
                        .numericText(value: convertedTemperature)
                    )
                }
            }
            .navigationTitle("TempConvert")
            .toolbar {
                Button {
                    inspectorShown = true
                } label: {
                    Label("Inspector", systemImage: "info.circle.fill")
                }
                .buttonStyle(.borderedProminent)
                if temperatureFieldIsFocused {
                    Button("Done", systemImage: "checkmark") {
                        temperatureFieldIsFocused = false
                    }
                }
            }
        
            .inspector(isPresented: $inspectorShown) {
                ScrollView {
                    CodeText(CodeSnippets.tempConvert)
                        .highlightLanguage(.swift)
                        .codeTextColors(.theme(.xcode))
                }
                .padding()
                .font(.callout)
            }
        }
        }
        }
        
        #Preview {
        TempConvert()
        }

        """#

    static let guessTheFlag = #"""
        //
        //  GuessTheFlag.swift
        //  HWS
        //
        //  Created by Radoslav Bley on 03/08/2025.
        //
        
        import HighlightSwift
        import SwiftUI
        
        struct GuessTheFlag: View {
        @State private var countries = [
        "Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland",
        "Spain", "UK", "Ukraine", "US",
        ].shuffled()
        @State private var correctAnswer = Int.random(in: 0...2)
        
        @State private var showingScore = false
        @State private var scoreTitle = ""
        @State private var score: Int = 0
        @State private var tries: Int = 0
        @State private var inspectorShown = false
        
        var body: some View {
        ZStack {
            RadialGradient(
                stops: [
                    .init(
                        color: Color(red: 0.1, green: 0.2, blue: 0.45),
                        location: 0
                    ), .init(color: .black, location: 1),
                ],
                center: .top,
                startRadius: 10,
                endRadius: 700
            )
            .ignoresSafeArea()
            VStack {
                Spacer()
        
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
        
                Spacer()
        
                VStack(spacing: 30) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
        
                        Text(countries[correctAnswer])
                            .foregroundStyle(.secondary)
                            .font(.largeTitle.weight(.semibold))
                    }
        
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 12, y: 10)
                        }
                    }
                }
                .frame(maxWidth: 500)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 20))
        
                Spacer()
                Spacer()
                Text("Score: \(score) / \(countries.count)")
                    .foregroundStyle(.white)
                    .font(.headline.bold())
                Spacer()
        
                Button {
                    inspectorShown = true
                } label: {
                    Label("Inspector", systemImage: "info.circle.fill")
                }
                .buttonStyle(.borderedProminent)
        
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .alert(scoreTitle, isPresented: $showingScore) {
            if tries < countries.count {
                Button("Continue", action: askQuestion)
            } else {
                Button("Start over", role: .destructive, action: restart)
            }
        } message: {
            if tries < countries.count {
                Text("Your score is \(score)")
            }
        }
        
        .inspector(isPresented: $inspectorShown) {
            ScrollView {
                CodeText(CodeSnippets.guessTheFlag)
                    .highlightLanguage(.swift)
                    .codeTextColors(.theme(.xcode))
            }
            .padding()
            .font(.callout)
        }
        }
        
        func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
            tries += 1
            if tries < countries.count {
                scoreTitle = "Correct!"
            } else {
                scoreTitle =
                    "Game Over! Your score is \(score) / \(countries.count)."
            }
        } else {
            tries += 1
        
            if tries < countries.count {
                scoreTitle = "Wrong! That's \(countries[number])"
            } else {
                scoreTitle =
                    "Game Over! Your score is \(score) / \(countries.count)."
            }
        }
        
        showingScore = true
        }
        
        func askQuestion() {
        countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...2)
        }
        
        func restart() {
        score = 0
        tries = 0
        print(score)
        }
        }
        
        #Preview {
        GuessTheFlag()
        }

        """#
}
