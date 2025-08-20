//
//  BetterRest.swift
//  BleyLog
//
//  Created by Radoslav Bley on 20/08/2025.
//

import CoreML
import SwiftUI

struct BetterRest: View {
    // States
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1.0
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var isEditing = false

    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }

    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker(
                        "Please enter a time",
                        selection: $wakeUp,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                }

                VStack(alignment: .leading) {
                    Text("Desired amount of sleep.")
                        .font(.headline)
                    #if !os(watchOS)
                        Stepper(
                            "\(sleepAmount.formatted()) hours",
                            value: $sleepAmount,
                            in: 4...12,
                            step: 0.25
                        )
                    #else
                        VStack {
                            Spacer()
                            Text("\(sleepAmount.formatted()) hours")
                                .font(.title2)
                                .contentTransition(.numericText())
                            HStack {
                                Button("Minus", systemImage: "minus") {
                                    withAnimation {
                                        sleepAmount = max(4, sleepAmount - 0.25)
                                    }
                                }
                                Button("Plus", systemImage: "plus") {
                                    withAnimation {
                                        sleepAmount = min(
                                            12,
                                            sleepAmount + 0.25
                                        )
                                    }
                                }
                            }
                            .buttonStyle(.bordered)
                            .labelStyle(.iconOnly)
                        }
                    #endif
                }

                VStack(alignment: .leading) {
                    Text("Daily coffee intake.")
                        .font(.headline)

                    #if !os(watchOS)
                        Stepper(
                            "^[\(coffeeAmount.formatted()) cup](inflect: true)",
                            value: $coffeeAmount,
                            in: 1...20
                        )
                    #else
                        VStack {
                            Spacer()
                            Text(
                                "^[\(coffeeAmount.formatted()) cup](inflect: true)"
                            )
                            .font(.title2)
                            .contentTransition(.numericText())
                            HStack {
                                Button("Minus", systemImage: "minus") {
                                    withAnimation {
                                        coffeeAmount = max(1, coffeeAmount - 1)
                                    }
                                }
                                Button("Plus", systemImage: "plus") {
                                    withAnimation {
                                        coffeeAmount = min(
                                            20,
                                            coffeeAmount + 1
                                        )
                                    }
                                }
                            }
                            .buttonStyle(.bordered)
                            .labelStyle(.iconOnly)
                        }
                    #endif
                }
                #if os(watchOS)
                    Button("Calculate", action: calculateBedtime)
                #endif

            }
            .navigationTitle("BetterRest")
            #if !os(watchOS)
                .toolbar {
                    Button("Calculate", action: calculateBedtime)
                }
            #elseif os(watchOS)
                .containerBackground(
                    .brown.gradient,
                    for: .navigation
                )
                .toolbarForegroundStyle(.brown, for: .automatic)
            #endif
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK") {}
            } message: {
                Text("You should go to bed at: \(alertMessage)")
            }
        }
    }

    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)

            let components = Calendar.current.dateComponents(
                [.hour, .minute],
                from: wakeUp
            )
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60

            let prediction = try model.prediction(
                wake: Double(hour + minute),
                estimatedSleep: sleepAmount,
                coffee: Double(coffeeAmount)
            )

            let sleepTime = wakeUp - prediction.actualSleep

            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)

        } catch {
            alertTitle = "Error"
            alertMessage =
                "There was a problem calculating your bedtime. Please try again."
        }

        showAlert = true
    }

}

#Preview {
    BetterRest()
}
