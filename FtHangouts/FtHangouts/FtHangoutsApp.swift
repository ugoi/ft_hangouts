//
//  FtHangoutsApp.swift
//  FtHangouts
//
//  Created by Stefan Dukic on 05.07.2024.
//

import SwiftUI

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
}

@main
struct FtHangoutsApp: App {
    @StateObject private var navigationManager = NavigationManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationManager)
        }
    }
}
