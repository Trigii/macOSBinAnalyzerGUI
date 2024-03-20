//
//  AllQueryListView.swift
//  MacOSBinAnalyzerGUI
//
//  Created by Tristán on 20/3/24.
//

import SwiftUI

import SwiftUI

struct AllQueryListView: View {
    // arguments
    let title: String
    @Binding var queryGroups: [QueryGroup]
    @Binding var selectedQuery: Query
    @Binding var databasePath: String
    @State private var newQuery = ""
    @State private var updateSuccessMessage = ""
    @State private var inspectorIsShown: Bool = false
    
    var body: some View {
        List {
            ForEach(queryGroups.indices, id: \.self) { index in
                let group = queryGroups[index]
                Section(header: Text(group.title)) {
                    ForEach(group.queries.indices, id: \.self) { queryIndex in
                        let query = group.queries[queryIndex]
                        QueryView(query: .constant(query), selectedQuery: $selectedQuery, inspectorIsShown: $inspectorIsShown, databasePath: $databasePath)
                    }
                }
            }
        }
        .navigationTitle(title) // display custom title for each query list
        .toolbar { // edit the toolbar of the query list view
            ToolbarItemGroup {
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
                            if let groupIndex = queryGroups.firstIndex(where: { $0.queries.contains(where: { $0.id == selectedQuery.id }) }) {
                                if let queryIndex = queryGroups[groupIndex].queries.firstIndex(where: { $0.id == selectedQuery.id }) {
                                    queryGroups[groupIndex].queries[queryIndex].query = newQuery
                                    updateSuccessMessage = "Query updated successfully" // Set success message
                                }
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
