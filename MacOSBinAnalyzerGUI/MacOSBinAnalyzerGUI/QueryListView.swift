//
//  QueryListView.swift
//  MacOSBinAnalyzerGUI
//
//  Created by Tristán on 18/3/24.
//
// View of a created query list

import SwiftUI
import SQLite3

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
                    queries.append(new_query) // TODO: add query options
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

// Function to perform query
/*
 // inspector configuration
 .inspector(isPresented: $inspectorIsShown){
     Group {
         if let selectedQuery = selectedQuery {
             // Perform the query and display the results
             VStack {
                 Text(selectedQuery.title).font(.title)
                 if let queryResults = executeQuery(selectedQuery.query, databasePath: databasePath) {
                     ForEach(queryResults, id: \.self) { rowResult in
                         ForEach(rowResult.sorted(by: <), id: \.key) { key, value in
                             HStack {
                                 Text("\(key):")
                                 Spacer()
                                 Text(value)
                                     .foregroundColor(.blue)
                             }
                         }
                         Divider()
                     }
                 } else {
                     Text("Error executing query.")
                 }
             }
         } else {
             Text("No query selected")
         }
     }.frame(maxWidth: .infinity)
 }
}

// Function to execute SQLite query and return the results
private func executeQuery(_ query: String?, databasePath: String) -> [String: String]? {
 guard let query = query else { return nil }
 var queryResult = [String: String]()
 
 var db: OpaquePointer?
 if sqlite3_open(databasePath, &db) == SQLITE_OK {
     var stmt: OpaquePointer?
     if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
         while sqlite3_step(stmt) == SQLITE_ROW {
             let columns = sqlite3_column_count(stmt)
             for i in 0..<columns {
                 if let columnName = sqlite3_column_name(stmt, i),
                    let columnValue = sqlite3_column_text(stmt, i) {
                     let key = String(cString: columnName)
                     let value = String(cString: columnValue)
                     queryResult[key] = value
                 }
             }
         }
         sqlite3_finalize(stmt)
     } else {
         print("Error preparing statement")
     }
     sqlite3_close(db)
 } else {
     print("Error opening database")
 }
 
 return queryResult.isEmpty ? nil : queryResult
}
*/
