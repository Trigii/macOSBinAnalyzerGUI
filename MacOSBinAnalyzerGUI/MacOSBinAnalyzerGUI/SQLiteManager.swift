//
//  SQLiteManager.swift
//  MacOSBinAnalyzerGUI
//
//  Created by Tristán on 19/3/24.
//

import SQLite3

class SQLiteManager {
    static func executeQuery(_ query: String?, databasePath: String) -> [[String: String]]? {
        guard let query = query else { return nil }
        var queryResults = [[String: String]]()
         
        var db: OpaquePointer?
        if sqlite3_open(databasePath, &db) == SQLITE_OK {
            var stmt: OpaquePointer?
            if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let columns = sqlite3_column_count(stmt)
                    var rowDict = [String: String]()
                    for i in 0..<columns {
                        if let columnName = sqlite3_column_name(stmt, i),
                            let columnValue = sqlite3_column_text(stmt, i) {
                            let key = String(cString: columnName)
                            let value = String(cString: columnValue)
                            rowDict[key] = value
                        }
                    }
                    queryResults.append(rowDict)
                }
                sqlite3_finalize(stmt)
            } else {
                print("Error preparing statement")
            }
            sqlite3_close(db)
        } else {
            print("Error opening database")
        }
        return queryResults.isEmpty ? nil : queryResults
    }
}

