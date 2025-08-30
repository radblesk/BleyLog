//
//  Bookworm.swift
//  BleyLog
//
//  Created by Radoslav Bley on 30/08/2025.
//

import SwiftData
import SwiftUI

struct Bookworm: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [
        SortDescriptor(\Book.rating, order: .reverse),
        SortDescriptor(\Book.title),
        SortDescriptor(\Book.author),
    ]) var books: [Book]

    @State private var showing: Bool = false

    var body: some View {
        VStack {
            List {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)

                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                    .foregroundStyle(book.rating == 1 ? .red : .primary)

                                Text(book.author)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationDestination(for: Book.self) { book in
                BookDetailView(book: book)
            }
        }
        .navigationTitle("Bookworm")
        .toolbar {
            #if os(iOS)
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
                if #available(iOS 26, *) {
                    ToolbarSpacer(.flexible, placement: .bottomBar)
                }
            #endif
            ToolbarItem(placement: .bottomBar) {
                Button("Add Book", systemImage: "plus") {
                    showing.toggle()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .sheet(isPresented: $showing) {
            AddBookView()
                .presentationDetents([.medium])
        }
    }

    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            modelContext.delete(book)
        }
    }
}

#Preview {
    NavigationStack {
        Bookworm()
            .environment(ModelData())
    }
}
