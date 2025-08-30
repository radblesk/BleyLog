//
//  BookDetailView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 30/08/2025.
//

import SwiftData
import SwiftUI

struct BookDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showing: Bool = false

    let book: Book

    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre)
                    .resizable()
                    .scaledToFit()
                    .apply {
                        if #available(iOS 26, watchOS 26, *) {
                            $0.backgroundExtensionEffect()
                        } else {
                            $0.disabled(false)
                        }
                    }

                HStack {
                    Text("Added: \(book.date.formatted(.dateTime.day().month().year()))")
                        #if os(iOS)
                            .fontWeight(.black)
                        #else
                            .font(.system(size: 10, weight: .bold))
                        #endif
                        .padding(8)
                        .foregroundStyle(.white)
                        .background(.ultraThinMaterial)
                        .clipShape(.capsule)

                    Spacer()

                    Text(book.genre.uppercased())
                        #if os(iOS)
                            .fontWeight(.black)
                        #else
                            .font(.system(size: 10, weight: .bold))
                        #endif
                        .padding(8)
                        .foregroundStyle(.white)
                        .background(.ultraThinMaterial)
                        .clipShape(.capsule)
                }
                .padding()
            }

            Text(book.author)
                #if os(iOS)
                    .font(.title)
                #else
                    .font(.title2)
                #endif
                .foregroundStyle(.secondary)

            Text(book.review)
                .padding()

            RatingView(rating: .constant(book.rating))
                #if os(iOS)
                    .font(.largeTitle)
                #endif
        }
        .ignoresSafeArea(edges: .top)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Delete book", isPresented: $showing) {
            Button("Delete", role: .destructive, action: deleteBook)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure?")
        }
        .toolbar {
            Button("Delete this book", systemImage: "trash") {
                showing = true
            }
        }
    }

    func deleteBook() {
        modelContext.delete(book)
        dismiss()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Book.self, configurations: config)
        let example = Book(
            title: "Test Book",
            author: "Test Author",
            genre: "Fantasy",
            review: "Great book!",
            rating: 5,
            date: Date.now
        )

        return NavigationStack {
            BookDetailView(book: example)
                .modelContainer(container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
