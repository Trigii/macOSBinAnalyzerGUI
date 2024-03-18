//
//  QueryListView.swift
//  MacOSBinAnalyzerGUI
//
//  Created by Tristán on 18/3/24.
//
// View of a created query list

import SwiftUI

struct QueryListView: View {
    // arguments
    let title: String
    @Binding var queries: [Query] // list of all queries to display
    @State private var selectedQuery: Query? = nil // keep track of the selected query for the inspector (to show query details)

    @State private var inspectorIsShown: Bool = false // state of the inspector (default: false)

    var body: some View {
        List($queries) { $query in //display all queries made
            QueryView(query: $query, selectedQuery: $selectedQuery, inspectorIsShown: $inspectorIsShown)
        }
        .navigationTitle(title) // display custom title for each query list
        .toolbar { // edit the toolbar of the query list view
            ToolbarItemGroup {
                // add query button
                Button {
                    queries.append(Query(title: "New Query")) // TODO: add query options
                } label: {
                    Label("Create New Query", systemImage: "plus")
                }

                // show inspector button
                Button {
                    inspectorIsShown.toggle() // if its clicked
                } label: {
                    Label("Show inspector", systemImage: "sidebar.right")
                }
            }
        }
        // inspector configuration
        .inspector(isPresented: $inspectorIsShown){
            Group {
                if let selectedQuery {
                    // TODO: perform the query and display the results in here
                    Text(selectedQuery.title).font(.title)
                } else {
                    Text("No query selected")
                }
            }.frame(minWidth: 100, maxWidth: .infinity)
        }
    }
}
