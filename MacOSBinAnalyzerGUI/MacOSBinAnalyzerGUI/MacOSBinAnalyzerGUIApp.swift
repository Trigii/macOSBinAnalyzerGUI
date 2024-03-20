//
//  MacOSBinAnalyzerGUIApp.swift
//  MacOSBinAnalyzerGUI
//
//  Created by Tristán on 18/3/24.
//

import SwiftUI

@main
struct MacOSBinAnalyzerGUI: App {
    @State private var databasePath: String = "" // Initial value for database path state
    @State private var selectedQuery: Query = Query(title: "") // Initial value for current query
    
    var body: some Scene {
        WindowGroup {
            ContentView(databasePath: $databasePath, selectedQuery: $selectedQuery)
        }
        WindowGroup("Run query", id: "run-query") {
            RunQueryView(query: $selectedQuery, databasePath: $databasePath)
        }
    }
}
