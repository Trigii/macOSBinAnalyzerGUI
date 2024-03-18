import SwiftUI

struct StaticQueryListView: View {
    // arguments
    let title: String
    let queries = [Query]

    var body: some View {
        List(queries) { query in //display all queries made
            HStack {
                Image(systemName: "plus.magnifyingglass")
                Text(query.title)
            }
        }
    }
}

#Preview {
    StaticQueryListView(title: "All", queries: Query.examples())
}