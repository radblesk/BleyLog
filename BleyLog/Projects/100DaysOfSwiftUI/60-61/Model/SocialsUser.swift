//
//  SocialsUser.swift
//  BleyLog
//
//  Created by Radoslav Bley on 31/08/2025.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class SocSDUser {
    var id: String = ""
    var isActive: Bool = false
    var name: String = ""
    var age: Int = 0
    var company: String = ""
    var email: String = ""
    var address: String = ""
    var about: String = ""
    var registered: Date = Date.now
    var tags: [String] = []
    @Relationship(deleteRule: .cascade) var friends: [SocSDFriend]? = [SocSDFriend]()

    var unwrappedFriends: [SocSDFriend] {
        friends ?? []
    }

    var formattedDate: String {
        registered.formatted(.dateTime.day().month().year())
    }

    init(
        id: String,
        isActive: Bool,
        name: String,
        age: Int,
        company: String,
        email: String,
        address: String,
        about: String,
        registered: Date,
        tags: [String],
        friends: [SocSDFriend]? = nil
    ) {
        self.id = id
        self.isActive = isActive
        self.name = name
        self.age = age
        self.company = company
        self.email = email
        self.address = address
        self.about = about
        self.registered = registered
        self.tags = tags
        self.friends = friends
    }
}

@Model
class SocSDFriend {
    var id: String = ""
    var name: String = ""
    var friendOf: SocSDUser?

    init(id: String, name: String, friendOf: SocSDUser? = nil) {
        self.id = id
        self.name = name
        self.friendOf = friendOf
    }
}

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
}

struct SocialsFriend: Codable {
    var id: String
    var name: String
}
