//
//  Checkout.swift
//  BleyLog
//
//  Created by Radoslav Bley on 29/08/2025.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order

    @State private var confirmationTitle: String = ""
    @State private var confirmationMessage: String = ""
    @State private var showingConfirmation: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)

                Text(
                    "Your total cost is \(order.cost, format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))"
                )
                .font(.title)

                Button("Place order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert(confirmationTitle, isPresented: $showingConfirmation) {
        } message: {
            Text(confirmationMessage)
        }
    }

    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }

        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("reqres-free-v1", forHTTPHeaderField: "x-api-key")
        request.httpMethod = "POST"

        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)

            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationTitle = "Thank You!"
            confirmationMessage =
                "Your order for \(decodedOrder.quantity) x \(Order.types[decodedOrder.type].lowercased()) is on its way"

            showingConfirmation = true
        } catch {
            confirmationTitle = "Ou nou"
            confirmationMessage = "There has been an error: \(error.localizedDescription)"
            showingConfirmation = true
        }
    }
}

#Preview {
    NavigationStack {
        CheckoutView(order: Order())
    }
}
