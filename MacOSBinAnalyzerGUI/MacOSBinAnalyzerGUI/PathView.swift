//
//  PathView.swift
//  MacOSBinAnalyzerGUI
//
//  Created by Tristán on 19/3/24.
//

import SwiftUI

struct PathView: View {
    @Binding var databasePath: String
    @State private var newPath = ""
    @State private var updateSuccessMessage = "" // Message to indicate successful update
    
    var body: some View {
        VStack {
            TextField(databasePath , text: $newPath)
                .frame(minWidth: 500, minHeight: 100)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            HStack {
                Button("Save") {
                    // Update the query title
                    databasePath = newPath
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
    }
}
