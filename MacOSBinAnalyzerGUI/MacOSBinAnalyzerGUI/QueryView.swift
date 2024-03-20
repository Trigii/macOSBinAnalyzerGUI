//
//  QueryView.swift
//  MacOSBinAnalyzerGUI
//
//  Created by Tristán on 18/3/24.
//

import SwiftUI
import SQLite3

struct QueryView: View {
    @Environment(\.openWindow) var openWindow
    
    @Binding var query: Query
    @Binding var selectedQuery: Query
    @Binding var inspectorIsShown: Bool
    @Binding var databasePath: String
    
    var body: some View {
        HStack {
            Image(systemName: "plus.magnifyingglass")
            TextField("New Query", text: $query.title).textFieldStyle(.plain)
            
            // query details button
            Button(action: {
                if inspectorIsShown && query.id==selectedQuery.id { // if details is pressed again it closes the inspector
                    inspectorIsShown = false
                }else { // open inspector for the first time
                    inspectorIsShown = true // update the inspector state
                    selectedQuery = query // update the selected query state
                }
            }, label: {
                Text("Details")
            })
            
            // run query button
            Button(action: {
                selectedQuery = query // update the selected query state
                openWindow(id: "run-query")
            }, label: {
                Text("Run query")
            })
        }
    }
}
