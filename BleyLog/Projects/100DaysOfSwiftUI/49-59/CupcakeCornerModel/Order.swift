//
//  Order.swift
//  BleyLog
//
//  Created by Radoslav Bley on 29/08/2025.
//

import Foundation

struct OrderAdress: Codable {
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
        case _name = "name"
        case _streetAdress = "street_adress"
        case _city = "city"
        case _zip = "zip"
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

    var name: String = ""
    var streetAdress: String = ""
    var city: String = ""
    var zip: String = ""

    var hasValidAdress: Bool {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || streetAdress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
