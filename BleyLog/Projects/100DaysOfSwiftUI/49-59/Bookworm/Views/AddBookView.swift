//
//  AddBookView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 30/08/2025.
//

import SwiftData
import SwiftUI

struct AddBookView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    // Book data
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var genre: String = "Fantasy"
    @State private var rating: Int = 3
    @State private var review: String = ""

    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]

    var isValid: Bool {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || review.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            return false
        }
        return true
    }

    var body: some View {
        Form {
            Section {
                TextField("Name of book", text: $title)
                TextField("Author's name", text: $author)

                Picker("Genre", selection: $genre) {
                    ForEach(genres, id: \.self) {
                        Text($0)
                    }
                }
            }

            Section("Write a review") {
                #if os(iOS)
                    TextEditor(text: $review)
                #else
                    TextField("Your review", text: $review)
                #endif

                RatingView(rating: $rating)
            }

            Section {
                Button("Save") {
                    let newBook = Book(
                        title: title,
                        author: author,
                        genre: genre,
                        review: review,
                        rating: rating,
                        date: Date.now
                    )

                    modelContext.insert(newBook)
                    dismiss()
                }
                .disabled(isValid == false)
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Add Book")
    }
}

#Preview {
    AddBookView()
}
