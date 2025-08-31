//
//  Book.swift
//  BleyLog
//
//  Created by Radoslav Bley on 30/08/2025.
//

import Foundation
import SwiftData

@Model
class Book {
    var title: String = "None"
    var author: String = "Unknown"
    var genre: String = "Unknown"
    var review: String = "None"
    var rating: Int = 0
    var date: Date = Date.now

    init(title: String, author: String, genre: String, review: String, rating: Int, date: Date) {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
        self.date = date
    }
}
