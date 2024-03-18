// View of the sidebar

import SwiftUI

struct SidebarView: View {
    @Binding var userCreatedGroups: [QueryGroup]
    @Binding var selection: QuerySection.all // to know what tab has been selected (modified by tag)

    var body: some View {
        List(slection: $selection) {
            Section("Favorites") {
                ForEach(QuerySection.allCases) { selection in
                    Label(selection.displayName, systemImage: selection.iconName).tag(selection) // display sidebar options
                }
            }
            
            Section("Your Queries") {
                ForEach($userCreatedGroups) { $group in
                    HStack {
                        Image(systemName: "folder")
                        TextField("New Group", text: $group.title)
                    }.tag(GroupSection.list(group)) // display sidebar options
                }
            }
        }
        
        // create query button (out of the list so its always visible)
        .safeAreaInset(edge: .bottom){
            Button(action: {
                let newGroup = QueryGroup(title: "New Group") // TODO: spawn a prompt so the user can give it a name
                userCreatedGroups.append(newGroup)
            }, label: {
                Label("Create Query Group", systemImage: "plus.circle")
            }).buttonStyle(.borderless).foregroundColor(.accentColor).padding().frame(maxWidth: .infinity, alignment: .leading)
        }

    }
}

#Preview {
    SidebarView(userCreatedGroups: .constant(QueryGroup.examples()), selection: .constant(.all)).listStyle(.sidebar)
}