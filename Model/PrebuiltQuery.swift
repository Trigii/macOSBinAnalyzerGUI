import Foundation

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