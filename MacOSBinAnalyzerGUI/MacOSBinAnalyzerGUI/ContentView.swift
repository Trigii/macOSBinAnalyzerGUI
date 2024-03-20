//
//  ContentView.swift
//  MacOSBinAnalyzerGUI
//
//  Created by Tristán on 18/3/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = QuerySection.all // sidebar selection state
    @State private var allQueries: [Query] = []
    @State private var prebuiltQueries: [Query] = [] // TODO: change to prebuilt queries hardcoded
    @State private var userCreatedGroups: [QueryGroup] = []
    @State private var searchTerm: String = ""
    @Binding var databasePath: String
    @Binding var selectedQuery: Query
    
    var body: some View {
        NavigationSplitView {
            SidebarView(userCreatedGroups: $userCreatedGroups, selection: $selection) // we navigate through the sidebar
        } detail: { // depends on the selected tab
            if searchTerm.isEmpty {
                switch selection {
                    case .path:
                        PathView(databasePath: $databasePath)
                    case .all:
                    QueryListView(title: "All", queries: $allQueries, selectedQuery: $selectedQuery, databasePath: $databasePath)
                    case .prebuilt:
                    PrebuildQueryListView(title: "Prebuilt Queries", selectedQuery: $selectedQuery, databasePath: $databasePath) // TODO: create a PrebuiltQueriesView that dont allow to add queries and contains the queries hardcoded.
                    case .list(let queryGroup):
                        // Create a binding for the queries in the selected query group
                        let groupQueries = $userCreatedGroups[getIndex(for: queryGroup)]
                    QueryListView(title: queryGroup.title, queries: groupQueries.queries, selectedQuery: $selectedQuery, databasePath: $databasePath)
                }
            } else {
                QueryListView(title: "All", queries: Binding(get: {self.allQueries.filter({ $0.title.contains(searchTerm) })}, set: { _ in }), selectedQuery: $selectedQuery, databasePath: $databasePath)
            }
            // StaticQueryListView() // and display the queries
        }
        .searchable(text: $searchTerm) // adds automatically the searchbar at the top
    }
    
    // Helper function to get the index of the selected query group
    private func getIndex(for queryGroup: QueryGroup) -> Int {
        if let index = userCreatedGroups.firstIndex(where: { $0.id == queryGroup.id }) {
            return index
        }
        return 0
    }
}
