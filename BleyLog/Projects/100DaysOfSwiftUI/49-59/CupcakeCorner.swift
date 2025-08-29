//
//  CupcakeCorner.swift
//  BleyLog
//
//  Created by Radoslav Bley on 28/08/2025.
//

import SwiftUI

struct CupcakeCorner: View {
    @State private var order = Order()

    var body: some View {
        Form {
            Section {
                Picker("Select your cake type", selection: $order.type) {
                    ForEach(Order.types.indices, id: \.self) {
                        Text(Order.types[$0])
                    }
                }

                #if os(iOS)
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                #else
                    Picker("Number of cakes:", selection: $order.quantity) {
                        ForEach(3...20, id: \.self) {
                            Text("\($0)")
                        }
                    }
                #endif
            }

            Section {
                Toggle("Any special requests?", isOn: $order.specialRequestEnabled)

                if order.specialRequestEnabled {
                    Toggle("Add extra frosting", isOn: $order.extraFrosting)

                    Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                }
            }

            Section {
                NavigationLink("Delivery details") {
                    AdressView(order: order)
                }
            }
        }
        .navigationTitle("Cupcake Corner")
    }
}

#Preview {
    NavigationStack {
        CupcakeCorner()
    }
}
