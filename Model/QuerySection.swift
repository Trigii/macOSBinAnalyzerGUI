import Foundation

enum QuerySection: Identifiable, CaseIterable, Hashable {
    case all
    case prebuilt
    case list(QueryGroup)

    var id: String {
        switch self {
            case .all:
                "all"
            case .prebuilt:
                "prebuilt"
            case .list(let queryGroup):
                queryGroup.id.uuidString
        }
    }

    var displayName: String {
        switch self {
            case .all:
                "All"
            case .prebuilt:
                "Prebuilt"
            case .list(let queryGroup):
                queryGroup.title
        }
    }

    var iconName: String {
        switch self {
            case .all:
                "star"
            case .prebuilt:
                "checkmark.circle"
            case .list(_):
                "folder"
        }
    }

    static var allCases: [QuerySection] {
        [.all, .prebuilt]
    }

    static func == (lhs: QuerySection, rhs: QuerySection) -> Bool {
        lhs.id == rhs.id
    }
}