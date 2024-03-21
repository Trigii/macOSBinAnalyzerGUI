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
                    if let groupIndex = queryGroups.firstIndex(where: { $0.queries.contains(where: { $0.id == selectedQuery.id }) }) {
                        if let queryIndex = queryGroups[groupIndex].queries.firstIndex(where: { $0.id == selectedQuery.id }) {
                            queryGroups[groupIndex].queries[queryIndex].query = newQuery
                            updateSuccessMessage = "Query updated successfully" // Set success message
                        }
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
