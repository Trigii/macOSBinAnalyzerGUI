//
//  PrebuildQueryListView.swift
//  MacOSBinAnalyzerGUI
//
//  Created by Tristán on 20/3/24.
//

import SwiftUI

struct PrebuildQueryListView: View {
    // arguments
    let title: String
    @Binding var selectedQuery: Query // keep track of the selected query for the inspector (to show query details)
    @State private var inspectorIsShown: Bool = false // state of the inspector (default: false)
    @Binding var databasePath: String
    @State private var newQuery = ""
    
    @State private var isExpanded: [Bool] // to track expansion state of categories

    init(title: String, selectedQuery: Binding<Query>, databasePath: Binding<String>) {
        self.title = title
        self._selectedQuery = selectedQuery
        self._databasePath = databasePath
        
        // Initialize isExpanded with false for each category
        _isExpanded = State(initialValue: Array(repeating: false, count: prebuildQueries.count))
    }

    var body: some View {
        ScrollView {
            ForEach(prebuildQueries.indices, id: \.self) { index in
                let category = prebuildQueries[index]
                
                DisclosureGroup(isExpanded: $isExpanded[index]) {
                    ForEach(category.queries) { query in
                        QueryView(query: .constant(query), selectedQuery: $selectedQuery, inspectorIsShown: $inspectorIsShown, databasePath: $databasePath)
                    }
                } label: {
                    Text(category.title)
                        .font(.headline)
                }
                .padding()
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
                if let query = selectedQuery.query {
                    Text("Query: \(query)")
                } else {
                    Text("Query: N/A")
                }
            }.frame(maxWidth: .infinity)
        }
    }

    let prebuildQueries: [PrebuiltQueryCategory] = [
        PrebuiltQueryCategory(title: "Privileged Binaries", queries: [
            Query(title: "Get executables with high privileges", isPreBuilt: true, query: "SELECT path, privileged, privilegedReasons FROM executables WHERE privileged='High';"),
            Query(title: "Get executables with medium privileges", isPreBuilt: true, query: "SELECT path, privileged, privilegedReasons FROM executables WHERE privileged='Medium';")
        ]),
        PrebuiltQueryCategory(title: "Injectable privileged binaries", queries: [
            Query(title: "Get executables with high privileges and injectable level medium or high", isPreBuilt: true, query: "SELECT path, privileged, privilegedReasons, injectable, injectableReasons FROM executables WHERE privileged='High' AND (injectable == 'Medium' OR injectable == 'High');"),
            Query(title: "Get executables with medium privileges and injectable level high", isPreBuilt: true, query: "SELECT path, privileged, privilegedReasons, injectable, injectableReasons FROM executables WHERE privileged='Medium' AND injectable == 'High';")
        ]),
        PrebuiltQueryCategory(title: "Specific Injection queries", queries: [
            Query(title: "Electron Apps", isPreBuilt: true, query: "SELECT path, privileged, privilegedReasons, injectable, injectableReasons FROM executables WHERE injectableReasons LIKE '%isElectron%';"),
            Query(title: "Get Electron app bundles", isPreBuilt: true, query: "SELECT bundle_path FROM bundles WHERE isElectron;"),
            Query(title: "Get DYLD_INSERT_LIBRARIES without library validation", isPreBuilt: true, query: "SELECT e.path, e.privileged, e.privilegedReasons FROM executables e WHERE e.noLibVal = 1 AND e.allowDyldEnv = 1;"),
            Query(title: "Macho Task Port", isPreBuilt: true, query: "SELECT path FROM executables where entitlements like '%com.apple.system-task-ports%';"),
            Query(title: "Get binaries with the entitlement com.apple.security.get-task-allow", isPreBuilt: true, query: "SELECT path FROM executables where entitlements like '%com.apple.security.get-task-allow%';"),
            Query(title: "Get Hijackable (Dyld hijack & Dlopen hijack) binaries", isPreBuilt: true, query: "SELECT e.path, e.privileged, e.privilegedReasons, l.path FROM executables e JOIN executable_libraries el ON e.path = el.executable_path JOIN libraries l ON el.library_path = l.path WHERE l.isHijackable = 1 AND e.noLibVal = 1;"),
            Query(title: "Get other potential Dlopen hijackable binaries", isPreBuilt: true, query: "SELECT e.path, e.privileged, e.privilegedReasons, l.path FROM executables e JOIN executable_libraries el ON e.path = el.executable_path JOIN libraries l ON el.library_path = l.path WHERE l.isDyld = 0 AND l.pathExists = 0 AND l.isHijackable = 0 AND e.noLibVal = 1;")
        ]),
        PrebuiltQueryCategory(title: "Executable Queries", queries: [
            Query(title: "Unrestricted executables", isPreBuilt: true, query: "SELECT path FROM executables where isRestricted=0;"),
            Query(title: "Unrestricted non Apple executables", isPreBuilt: true, query: "SELECT path FROM executables where isRestricted=0 and isAppleBin=0;"),
            Query(title: "Executables with sandbox exceptions", isPreBuilt: true, query: "SELECT path FROM executables WHERE sandboxDefinition != '';"),
            Query(title: "Executables with ACLs", isPreBuilt: true, query: "SELECT path FROM executables WHERE acls != '';"),
            Query(title: "Executables with XPC rules", isPreBuilt: true, query: "SELECT path, xpcRules FROM executables WHERE xpcRules != '{}';"),
            Query(title: "Executables with TCC perms", isPreBuilt: true, query: "SELECT path, tccPerms FROM executables WHERE tccPerms != '';"),
            Query(title: "Executables with macServices", isPreBuilt: true, query: "SELECT path, machServices FROM executables WHERE machServices != '';")
        ]),
        PrebuiltQueryCategory(title: "Bundles Queries", queries: [
            Query(title: "Bundles with exposed schemes", isPreBuilt: true, query: "SELECT bundle_path, schemes FROM bundles WHERE schemes != '';"),
            Query(title: "Bundles with exposed utis", isPreBuilt: true, query: "SELECT bundle_path, utis FROM bundles WHERE utis != '';")
        ])
    ]
}

// Struct to hold prebuilt query categories
struct PrebuiltQueryCategory: Identifiable {
    let id = UUID()
    let title: String
    let queries: [Query]
}

private func example() -> Query {
    Query(title: "Get exec with high privs", isPreBuilt: true, query: "SELECT path, privileged, privilegedReasons FROM executables WHERE privileged='High';", searchResult: ["column1": "result1", "column2": "result2"])
}
