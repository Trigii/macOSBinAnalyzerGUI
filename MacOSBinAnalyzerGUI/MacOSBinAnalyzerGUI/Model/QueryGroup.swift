//
//  QueryGroup.swift
//  MacOSBinAnalyzerGUI
//
//  Created by Tristán on 18/3/24.
//

import Foundation

struct QueryGroup: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var queries: [Query]

    init(title: String, queries: [Query] = []) {
        self.title = title
        self.queries = queries
    }

    static func example() -> QueryGroup {
        let query1 = Query(title: "Get executables with high privileges")
        let query2 = Query(title: "Get executables with medium privileges and injectable level high")
        
        var group = QueryGroup(title: "Basic Queries")
        group.queries = [query1, query2]
        return group
    }

    static func examples() -> [QueryGroup] {
        let group1 = QueryGroup.example()
        let group2 = QueryGroup(title: "New queries")
        return [group1, group2]
    }
}
