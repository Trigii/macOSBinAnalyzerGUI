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
    @Binding var selectedQuery: Query // keep track of the selected query for the inspector (to show query details)
    @State private var inspectorIsShown: Bool = false // state of the inspector (default: false)
    @Binding var databasePath: String
    @State private var newQuery = ""
    @State private var updateSuccessMessage = "" // Message to indicate successful update
    
    var body: some View {
        List($queries) { $query in //display all queries made
            QueryView(query: $query, selectedQuery: $selectedQuery, inspectorIsShown: $inspectorIsShown, databasePath: $databasePath)
        }
        .navigationTitle(title) // display custom title for each query list
        .toolbar { // edit the toolbar of the query list view
            ToolbarItemGroup {
                // add query button
                Button {
                    let new_query = Query(title: "New Query")
                    queries.append(new_query)
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
                let selectedQuery = selectedQuery
                Text(selectedQuery.title).font(.title)
                Text("Path: \(databasePath)").font(.subheadline)
                Text("isPreBuilt: \(String(selectedQuery.isPreBuilt))").font(.subheadline)
                VStack {
                    TextField(selectedQuery.query ?? "Enter Query", text: $newQuery)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    HStack {
                        Button("Save") {
                            // Update the query's query property
                            if let index = queries.firstIndex(where: { $0.id == selectedQuery.id }) {
                                queries[index].query = newQuery
                                updateSuccessMessage = "Query updated successfully" // Set success message
                            }
                        }
                        .padding()
                    }
                    
                    // Display success message if available
                    if !updateSuccessMessage.isEmpty {
                        Text(updateSuccessMessage)
                            .foregroundColor(.green)
                            .padding()
                    }
                }
                .padding()
            }.frame(maxWidth: .infinity)
        }
    }
}
