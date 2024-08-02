//
//  FtHangoutsApp.swift
//  FtHangouts
//
//  Created by Stefan Dukic on 05.07.2024.
//

import SwiftData
import SwiftUI

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
}

@main
struct FtHangoutsApp: App {
    let container: ModelContainer
    @StateObject private var navigationManager = NavigationManager()

    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext)
                .environmentObject(navigationManager)
        }
        .modelContainer(container)
    }

    init() {
        do {
            container = try ModelContainer(for: SwiftDataContact.self, SwiftDataTimeSetInBackground.self)
        } catch {
            fatalError("Failed to create ModelContainer for Movie.")
        }
    }
}
