//
//  RunQueryView.swift
//  MacOSBinAnalyzerGUI
//
//  Created by Tristán on 19/3/24.
//

import SwiftUI

struct RunQueryView: View {
    @Binding var query: Query
    @Binding var databasePath: String
    
    var body: some View {
        if let queryResults = SQLiteManager.executeQuery(query.query, databasePath: databasePath) {
            if !queryResults.isEmpty {
                List {
                    ForEach(queryResults, id: \.self) { row in
                        QueryResultRowView(row: row)
                    }
                }
                .listStyle(PlainListStyle())
            } else {
                Text("No results found")
                    .foregroundColor(.red)
                    .padding()
            }
        } else {
            Text("Error executing query")
                .foregroundColor(.red)
                .padding()
        }
    }
}

struct QueryResultRowView: View {
    var row: [String: String]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(row.sorted(by: <), id: \.key) { (key, value) in
                HStack {
                    Text(key)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text(value)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.horizontal)
    }
}

