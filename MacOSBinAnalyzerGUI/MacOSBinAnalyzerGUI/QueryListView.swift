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
        .inspector(isPresented: $inspectorIsShown) {
            VStack(alignment: .leading, spacing: 16) {
                Text(selectedQuery.title)
                    .font(.title)
                    .foregroundColor(Color.blue)
                    .padding(.bottom, 8)
                
                Text("Database Path:")
                    .font(.headline)
                    .foregroundColor(Color.gray)
                
                Text(databasePath)
                    .font(.body)
                    .foregroundColor(Color.black)
                    .padding(.bottom, 8)
                
                Text("Is Prebuilt:")
                    .font(.headline)
                    .foregroundColor(Color.gray)
                
                Text(selectedQuery.isPreBuilt ? "Yes" : "No")
                    .font(.body)
                    .foregroundColor(Color.black)
                    .padding(.bottom, 8)
                
                Divider()
                
                Text("Current Query:")
                    .font(.headline)
                    .foregroundColor(Color.gray)
                
                Text(selectedQuery.query ?? "N/A")
                    .font(.body)
                    .foregroundColor(Color.black)
                    .padding(.bottom, 8)
                
                Divider()
                
                Text("Edit Query:")
                    .font(.headline)
                    .foregroundColor(Color.gray)
                
                TextField(selectedQuery.query ?? "Enter Query", text: $newQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        // Pre-populate the text field with the previously set query
                        newQuery = selectedQuery.query ?? ""
                    }
                
                Divider()
                
                Button("Save") {
                    // Update the query's query property
                    if let index = queries.firstIndex(where: { $0.id == selectedQuery.id }) {
                        queries[index].query = newQuery
                        updateSuccessMessage = "Query updated successfully" // Set success message
                    }
                }
                .buttonStyle(FilledButtonStyle())
                .padding(.vertical, 12)
                
                // Display success message if available
                if !updateSuccessMessage.isEmpty {
                    Text(updateSuccessMessage)
                        .foregroundColor(.green)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
        }




    }
}

struct FilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(configuration.isPressed ? Color.blue.opacity(0.8) : Color.blue)
            .cornerRadius(8)
    }
}
