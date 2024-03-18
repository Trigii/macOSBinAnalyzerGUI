//
//  Query.swift
//  MacOSBinAnalyzerGUI
//
//  Created by Tristán on 18/3/24.
//

import Foundation

struct Query: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var isPreBuilt: Bool
    var query: String?
    var searchResult: [String: String]

    init(title: String, isPreBuilt: Bool = false, query: String? = nil, searchResult: [String: String] = [:]) {
        self.title = title
        self.isPreBuilt = isPreBuilt
        self.query = query
        self.searchResult = searchResult
    }

    static func example() -> Query {
        Query(title: "Get exec with high privs", isPreBuilt: true, query: "SELECT path, privileged, privilegedReasons FROM executables WHERE privileged='High';", searchResult: ["column1": "result1", "column2": "result2"])
    }
    
    static func examples() -> [Query] {
        [
            Query(title: "This is a super query"),
            Query(title: "This is a super query2"),
            Query(title: "This is a super query3!"),
            Query(title: "Get executables with medium privileges and injectable level high", isPreBuilt: true, query: "SELECT path, privileged, privilegedReasons, injectable, injectableReasons FROM executables WHERE privileged='Medium' AND injectable == 'High';", searchResult: ["column1": "result1", "column2": "result2"])
        ]
    }
}