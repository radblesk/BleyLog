//
//  BleyLogWatchApp.swift
//  BleyLog
//
//  Created by Radoslav Bley on 19/08/2025.
//

import SwiftData
import SwiftUI

@main
struct BleyLogWatch_Watch_AppApp: App {
    /// An object that manages the app's data and state.
    @State private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(modelData)
        }
        .modelContainer(for: [
            Book.self, WSUsedWord.self, WSPlayer.self, User.self, ExpenseItem.self, UserModel.self, FriendModel.self,
        ])
    }
}
