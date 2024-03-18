//
//  QueryView.swift
//  MacOSBinAnalyzerGUI
//
//  Created by Tristán on 18/3/24.
//

import SwiftUI

struct QueryView: View {
    @Binding var query: Query
    @Binding var selectedQuery: Query?
    @Binding var inspectorIsShown: Bool

    var body: some View {
        HStack {
            // TODO: add on double click -> modify query params and perform the query
            Image(systemName: "plus.magnifyingglass")
            TextField("New Query", text: $query.title).textFieldStyle(.plain)

            Button(action: {
                inspectorIsShown = true // update the inspector state
                selectedQuery = query // update the selected query state
            }, label: {
                Text("Run")
            })
        }
    }
}
