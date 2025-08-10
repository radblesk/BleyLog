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
