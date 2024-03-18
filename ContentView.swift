//
//  ContentView.swift
//  GUI
//
//  Created by Tristán on 4/3/24.
//

import SwiftUI
import SQLite3

struct ContentView: View {
    enum Tab {
        case customQuery
        case prebuiltQueries
        case selectDatabase
    }
    
    @State private var selectedTab: Tab? = .customQuery
    @State private var searchText = ""
    @State private var searchResult = [[String]]()
    @State private var columnNames = [String]()
    @State private var selectedColumns = [String]() // Store selected columns
    @State private var filterText = "" // Store filter criteria
    @State private var dbPath = "" // Store path to database
    @State private var errorMessage = "" // Store error message
    
    // Define an array of colors for columns and values
    let columnColors: [Color] = [.red, .blue, .green, .orange, .purple, .yellow]
    
    var body: some View {
        NavigationView {
            // Sidebar with tab options
            List {
                Section("Configuration"){
                    NavigationLink(destination: SelectDatabaseView(dbPath: $dbPath), tag: Tab.selectDatabase, selection: $selectedTab) {
                        Label("Select Database", systemImage: "folder.fill")
                    }
                }
                Section("Queries"){
                    NavigationLink(destination: customQueryTab, tag: Tab.customQuery, selection: $selectedTab) {
                        Label("Custom Query", systemImage: "pencil.circle.fill")
                    }
                    
                    NavigationLink(destination: prebuiltQueriesTab, tag: Tab.prebuiltQueries, selection: $selectedTab) {
                        Label("Prebuilt Queries", systemImage: "list.bullet.rectangle.fill")
                    }
                }
            }
            .listStyle(SidebarListStyle())
            .frame(width: 200)
            .navigationTitle("Queries")
            
            // Main content area
            VStack {
                if selectedTab == .customQuery {
                    customQueryTab
                } else if selectedTab == .prebuiltQueries {
                    prebuiltQueriesTab
                }
                Spacer()
            }
            .padding()
        }
    }
    
    private var customQueryTab: some View {
        VStack {
            Text("Custom Query")
                .font(.title)
                .padding(.bottom, 20)
            
            TextField("Enter SQLite query", text: $searchText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Enter filter criteria", text: $filterText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                // Perform query here
                self.performQuery()
                
                // Select all columns by default
                self.selectedColumns = self.columnNames
            }) {
                Text("Run Query")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            // Show error message if present
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top)
            }
            
            // Show column selection options
            ScrollView(.horizontal) {
                HStack {
                    ForEach(columnNames, id: \.self) { columnName in
                        Button(action: {
                            if self.selectedColumns.contains(columnName) {
                                self.selectedColumns.removeAll(where: { $0 == columnName })
                            } else {
                                self.selectedColumns.append(columnName)
                            }
                        }) {
                            Text(columnName)
                                .padding()
                                .frame(minWidth: 100)
                                .background(self.selectedColumns.contains(columnName) ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top)
            
            // Show filtered output based on selected columns and filter criteria
            List {
                ForEach(searchResult.indices, id: \.self) { rowIndex in
                    let rowValues = searchResult[rowIndex]
                    if self.shouldShowRow(rowValues) {
                        HStack {
                            ForEach(rowValues.indices, id: \.self) { columnIndex in
                                if self.selectedColumns.contains(self.columnNames[columnIndex]) {
                                    Text(rowValues[columnIndex])
                                        .padding()
                                        .frame(minWidth: 100)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding()
    }
    
    struct SearchBar: View {
        @Binding var text: String
        var placeholder: String

        var body: some View {
            HStack {
                TextField(placeholder, text: $text)
                    .padding(.leading, 30)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                Image(systemName: "magnifyingglass")
                    .padding(.horizontal, 10)
                    .foregroundColor(.gray)
            }
        }
    }

    // Prebuilt Queries Tab
    private var prebuiltQueriesTab: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Categories of prebuilt queries
                ForEach(prebuiltQueryCategories.indices, id: \.self) { categoryIndex in
                    let category = self.prebuiltQueryCategories[categoryIndex]
                    
                    // Display collapsible section header
                    CollapsibleSection(title: category.title) {
                        // Display prebuilt queries in the category
                        LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                            ForEach(category.queries.indices, id: \.self) { queryIndex in
                                let query = category.queries[queryIndex]
                                Button(action: {
                                    // Set the searchText to the prebuilt query and perform the query
                                    self.searchText = query.query
                                    self.performQuery()
                                    
                                    // Select all columns after performing the prebuilt query
                                    self.selectedColumns = self.columnNames
                                    
                                    // Switch to the custom query tab
                                    self.selectedTab = .customQuery
                                }) {
                                    Text(query.title)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }

    
    struct CollapsibleSection<Content: View>: View {
        let title: String
        let content: Content
        @State private var isExpanded: Bool = true
        
        init(title: String, @ViewBuilder content: () -> Content) {
            self.title = title
            self.content = content()
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Button(action: {
                    self.isExpanded.toggle()
                }) {
                    HStack {
                        Text(title)
                            .font(.headline)
                        Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                            .foregroundColor(.gray)
                            .imageScale(.small)
                            .rotationEffect(.degrees(isExpanded ? 90 : 0))
                    }
                }
                if isExpanded {
                    content
                }
            }
        }
    }

    // View for selecting database path
    struct SelectDatabaseView: View {
        @Binding var dbPath: String
        
        var body: some View {
            VStack {
                Text("Select Database Path")
                    .font(.title)
                    .padding()
                
                // Add your UI for selecting the database path here
                // For example, you can use a FilePicker or a TextField
                TextField("Enter path to database", text: $dbPath)
                    .padding()
                
                Spacer()
            }
        }
    }
    
    // Function to perform query
    func performQuery() {
        // Check if the database file exists at the specified path
        if !FileManager.default.fileExists(atPath: dbPath) {
            errorMessage = "Database file not found"
            return
        }
        
        var db: OpaquePointer?
        var queryStatement: OpaquePointer?
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            if sqlite3_prepare_v2(db, searchText, -1, &queryStatement, nil) == SQLITE_OK {
                // Clear previous results and column names
                searchResult.removeAll()
                columnNames.removeAll()
                
                // Extract column names
                let columns = sqlite3_column_count(queryStatement)
                for i in 0..<columns {
                    if let columnName = sqlite3_column_name(queryStatement, i) {
                        columnNames.append(String(cString: columnName))
                    }
                }
                
                // Loop through the results and append to searchResult
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    var rowArray = [String]()
                    for i in 0..<columns {
                        if let queryResultCol = sqlite3_column_text(queryStatement, i) {
                            let value = String(cString: queryResultCol)
                            rowArray.append(value)
                        }
                    }
                    searchResult.append(rowArray)
                }
                
                // Reset error message
                errorMessage = ""
            } else {
                errorMessage = "Invalid query"
                print("Query could not be prepared")
            }
            
            sqlite3_finalize(queryStatement)
            sqlite3_close(db)
        } else {
            errorMessage = "Unable to open database"
            print("Unable to open database")
        }
    }
    
    func shouldShowRow(_ rowValues: [String]) -> Bool {
        if filterText.isEmpty {
            return true
        }
        // Split filter criteria into individual conditions
        let conditions = filterText.components(separatedBy: "&&")
        
        // Check each condition against the corresponding column value
        for condition in conditions {
            let components = condition.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "=")
            if components.count == 2 {
                let columnName = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let value = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
                if let columnIndex = columnNames.firstIndex(of: columnName) {
                    let columnValue = rowValues[columnIndex]
                    if !columnValue.localizedCaseInsensitiveContains(value) {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    // Struct to hold prebuilt query information
    struct PrebuiltQuery {
        let title: String
        let query: String
    }
    
    // Struct to hold prebuilt query categories
    struct PrebuiltQueryCategory {
        let title: String
        let queries: [PrebuiltQuery]
    }
    
    // Array of prebuilt query categories
    let prebuiltQueryCategories: [PrebuiltQueryCategory] = [
        PrebuiltQueryCategory(title: "Privileged Binaries", queries: [
            PrebuiltQuery(title: "Get executables with high privileges", query: "SELECT path, privileged, privilegedReasons FROM executables WHERE privileged='High';"),
            PrebuiltQuery(title: "Get executables with medium privileges", query: "SELECT path, privileged, privilegedReasons FROM executables WHERE privileged='Medium';")
        ]),
        PrebuiltQueryCategory(title: "Injectable privileged binaries", queries: [
            PrebuiltQuery(title: "Get executables with high privileges and injectable level medium or high", query: "SELECT path, privileged, privilegedReasons, injectable, injectableReasons FROM executables WHERE privileged='High' AND (injectable == 'Medium' OR injectable == 'High');"),
            PrebuiltQuery(title: "Get executables with medium privileges and injectable level high", query: "SELECT path, privileged, privilegedReasons, injectable, injectableReasons FROM executables WHERE privileged='Medium' AND injectable == 'High';")
        ]),
        PrebuiltQueryCategory(title: "Specific Injection queries", queries: [
            PrebuiltQuery(title: "Electron Apps", query: "SELECT path, privileged, privilegedReasons, injectable, injectableReasons FROM executables WHERE injectableReasons LIKE '%isElectron%';"),
            PrebuiltQuery(title: "Get Electron app bundles", query: "SELECT bundle_path FROM bundles WHERE isElectron;"),
            PrebuiltQuery(title: "Get DYLD_INSERT_LIBRARIES without library validation", query: "SELECT e.path, e.privileged, e.privilegedReasons FROM executables e WHERE e.noLibVal = 1 AND e.allowDyldEnv = 1;"),
            PrebuiltQuery(title: "Macho Task Port", query: "SELECT path FROM executables where entitlements like '%com.apple.system-task-ports%';"),
            PrebuiltQuery(title: "Get binaries with the entitlement com.apple.security.get-task-allow", query: "SELECT path FROM executables where entitlements like '%com.apple.security.get-task-allow%';"),
            PrebuiltQuery(title: "Get Hijackable (Dyld hijack & Dlopen hijack) binaries", query: "SELECT e.path, e.privileged, e.privilegedReasons, l.path FROM executables e JOIN executable_libraries el ON e.path = el.executable_path JOIN libraries l ON el.library_path = l.path WHERE l.isHijackable = 1 AND e.noLibVal = 1;"),
            PrebuiltQuery(title: "Get other potential Dlopen hijackable binaries", query: "SELECT e.path, e.privileged, e.privilegedReasons, l.path FROM executables e JOIN executable_libraries el ON e.path = el.executable_path JOIN libraries l ON el.library_path = l.path WHERE l.isDyld = 0 AND l.pathExists = 0 AND l.isHijackable = 0 AND e.noLibVal = 1;")
        ]),
        PrebuiltQueryCategory(title: "Executable Queries", queries: [
            PrebuiltQuery(title: "Unrestricted executables", query: "SELECT path FROM executables where isRestricted=0;"),
            PrebuiltQuery(title: "Unrestricted non Apple executables", query: "SELECT path FROM executables where isRestricted=0 and isAppleBin=0;"),
            PrebuiltQuery(title: "Executables with sandbox exceptions", query: "SELECT path FROM executables WHERE sandboxDefinition != '';"),
            PrebuiltQuery(title: "Executables with ACLs", query: "SELECT path FROM executables WHERE acls != '';"),
            PrebuiltQuery(title: "Executables with XPC rules", query: "SELECT path, xpcRules FROM executables WHERE xpcRules != '{}';"),
            PrebuiltQuery(title: "Executables with TCC perms", query: "SELECT path, tccPerms FROM executables WHERE tccPerms != '';"),
            PrebuiltQuery(title: "Executables with macServices", query: "SELECT path, machServices FROM executables WHERE machServices != '';")
        ]),
        PrebuiltQueryCategory(title: "Bundles Queries", queries: [
            PrebuiltQuery(title: "Bundles with exposed schemes", query: "SELECT bundle_path, schemes FROM bundles WHERE schemes != '';"),
            PrebuiltQuery(title: "Bundles with exposed utis", query: "SELECT bundle_path, utis FROM bundles WHERE utis != '';")
        ])
    ]
}
