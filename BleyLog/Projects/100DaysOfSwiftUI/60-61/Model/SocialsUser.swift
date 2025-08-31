//
//  SocialsUser.swift
//  BleyLog
//
//  Created by Radoslav Bley on 31/08/2025.
//

import Foundation
import SwiftUI

struct SocialsUser: Codable {
    var id: String
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    var friends: [SocialsFriend]
    
    var formattedDate: String {
        registered.formatted(.dateTime.day().month().year())
    }
}

struct SocialsFriend: Codable {
    var id: String
    var name: String
}
