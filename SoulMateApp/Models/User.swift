import Foundation

enum UserRole: String, Codable, CaseIterable, Identifiable {
    case seeker
    case penpal

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .seeker: return "Seeker"
        case .penpal: return "Penpal"
        }
    }

    var subtitle: String {
        switch self {
        case .seeker: return "Find someone to listen"
        case .penpal: return "Be there for others"
        }
    }
}

enum Mood: String, Codable, CaseIterable, Identifiable {
    case anxious
    case lonely
    case stressed
    case excited
    case reflective
    case grateful

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .anxious: return "😰"
        case .lonely: return "🌙"
        case .stressed: return "⚡️"
        case .excited: return "✨"
        case .reflective: return "🪞"
        case .grateful: return "🙏"
        }
    }

    var label: String {
        rawValue.capitalized
    }
}

struct User: Identifiable, Codable, Equatable {
    let id: String
    var displayName: String
    var role: UserRole
    var tokenBalance: Int
    var isAvailable: Bool
    var preferredMoods: [Mood]

    static func anonymous(role: UserRole) -> User {
        User(
            id: UUID().uuidString,
            displayName: role == .seeker ? "Seeker" : "Penpal",
            role: role,
            tokenBalance: role == .seeker ? 3 : 0,
            isAvailable: role == .penpal,
            preferredMoods: []
        )
    }
}

struct PenpalProfile: Identifiable, Equatable {
    let id: String
    let name: String
    let tagline: String
    let moods: [Mood]
    let rating: Double
    let isOnline: Bool
}
