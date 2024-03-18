import SwiftUI

struct ContentView: View {
    @State private var selection = QuerySection.prebuilt // sidebar selection state
    @State private var allQueries = Query.examples()
    @State private var prebuiltQueries = Query.examples() // TODO: change to prebuilt queries hardcoded
    @State private var userCreatedGroups: [QueryGroup] = QueryGroup.examples()
    @State private var searchTerm: String = ""

    var body: some View {
        NavigationSplitView {
            SidebarView(userCreatedGroups: $userCreatedGroups, selection: $selection) // we navigate through the sidebar
        } detail: { // depends on the selected tab
            if $searchTerm.isEmpty {
                switch selection {
                    case .all:
                        QueryListView(title: "All", queries: $allQueries)
                    case .prebuilt:
                        StaticQueryListView(title: "Prebuilt Queries", queries: $prebuiltQueries) // TODO: change to prebuilt queries hardcoded
                    case .list(let queryGroup):
                        StaticQueryListView(title: queryGroup, queries: queryGroup.queries)
                }
            } else {
                StaticQueryListView(title: "All", queries: allQueries.filter({ $0.title.contains(searchTerm) }))
            }
            // StaticQueryListView() // and display the queries
        }
        .searchable(text: $searchTerm) // adds automatically the searchbar at the top
    }
}