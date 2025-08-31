//
//  ExpenseItem.swift
//  BleyLog
//
//  Created by Radoslav Bley on 31/08/2025.
//

import Foundation
import SwiftData

@Model
class ExpenseItem {
    var name: String = "None"
    var type: String = "Unknown"
    var amount: Double = 0.0
    
    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }
}
