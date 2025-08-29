//
//  AdressView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 29/08/2025.
//

import SwiftUI

struct AdressView: View {
    enum Field {
        case name, streetAdress, city, zip
    }
    @Bindable var order: Order
    
    @FocusState private var focusedField: Field?

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                    .textContentType(.name)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .name)
                    .onSubmit {
                        focusedField = .streetAdress
                    }
                
                TextField("Street Adress", text: $order.streetAdress)
                    .textContentType(.streetAddressLine1)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .streetAdress)
                    .onSubmit {
                        focusedField = .city
                    }
                
                TextField("City", text: $order.city)
                    .textContentType(.addressCity)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .city)
                    .onSubmit {
                        focusedField = .zip
                    }
                
                TextField("Zip", text: $order.zip)
                    .textContentType(.postalCode)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .zip)
            }

            Section {
                NavigationLink("Check out") {
                    CheckoutView(order: order)
                }
            }
            .disabled(order.hasValidAdress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            focusedField = .name
        }
    }
}

#Preview {
    NavigationStack {
        AdressView(order: Order())
    }
}
