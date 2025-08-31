//
//  WSGameSave.swift
//  BleyLog
//
//  Created by Radoslav Bley on 30/08/2025.
//

import Foundation
import SwiftData

@Model
class WSUsedWord {
    var text: String = "None"
    var createdAt: Date = Date.now

    init(text: String, createdAt: Date) {
        self.text = text
        self.createdAt = createdAt
    }
}
