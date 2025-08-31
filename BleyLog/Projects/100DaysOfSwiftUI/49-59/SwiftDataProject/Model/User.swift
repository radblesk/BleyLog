//
//  User.swift
//  BleyLog
//
//  Created by Radoslav Bley on 31/08/2025.
//

import Foundation
import SwiftData

@Model
class User {
    var name: String = "New user"
    var city: String = "Unknown"
    var joinDate: Date = Date.now
    @Relationship(deleteRule: .cascade) var jobs: [Job]? = [Job]()
    
    var unwrappedJobs: [Job] {
        jobs ?? []
    }

    init(name: String, city: String, joinDate: Date) {
        self.name = name
        self.city = city
        self.joinDate = joinDate
    }
}
