//
//  Mission.swift
//  BleyLog
//
//  Created by Radoslav Bley on 27/08/2025.
//

import Foundation

struct Mission: Codable, Identifiable {
    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String

    struct CrewRole: Codable {
        let name: String
        let role: String
    }

    var displayName: String {
        "Apollo \(id)"
    }

    var image: String {
        "apollo\(id)"
    }
    
    var formattedLaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
}
