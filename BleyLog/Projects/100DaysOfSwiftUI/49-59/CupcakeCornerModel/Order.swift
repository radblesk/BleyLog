//
//  Order.swift
//  BleyLog
//
//  Created by Radoslav Bley on 29/08/2025.
//

import Foundation

struct OrderAddress: Identifiable, Codable {
    var id = UUID()
    var name: String
    var streetAdress: String
    var city: String
    var zip: String
}

@Observable
class Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _address = "address"
    }

    static let types: [String] = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    var type: Int = 0
    var quantity: Int = 3

    var specialRequestEnabled: Bool = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting: Bool = false
    var addSprinkles: Bool = false

    var address: OrderAddress {
        didSet {
            if let encodedAddress = try? JSONEncoder().encode(address) {
                UserDefaults.standard.set(encodedAddress, forKey: "CupcakeCornerAddress")
            }
        }
    }

    init() {
        if let savedAddress = UserDefaults.standard.data(forKey: "CupcakeCornerAddress") {
            if let decodedAddress = try? JSONDecoder().decode(OrderAddress.self, from: savedAddress) {
                address = decodedAddress
                return
            }
        }
        address = OrderAddress(name: "", streetAdress: "", city: "", zip: "")
    }

    var hasValidAdress: Bool {
        if address.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || address.streetAdress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || address.city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || address.zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            return false
        }

        return true
    }

    var cost: Decimal {
        var cost = Decimal(quantity) * 2

        cost += Decimal(type) / 2

        if extraFrosting {
            cost += Decimal(quantity)
        }

        if addSprinkles {
            cost += Decimal(quantity) / 2
        }

        return cost
    }
}
