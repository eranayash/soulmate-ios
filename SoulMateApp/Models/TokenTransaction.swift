import Foundation

enum TokenTransactionKind: String, Codable {
    case chatChunkDebit
    case chatChunkCredit
    case topUp
    case welcomeBonus
}

struct TokenTransaction: Identifiable, Codable, Equatable {
    let id: String
    let userID: String
    let kind: TokenTransactionKind
    let amount: Int
    let sessionID: String?
    let createdAt: Date
    let note: String

    init(
        id: String = UUID().uuidString,
        userID: String,
        kind: TokenTransactionKind,
        amount: Int,
        sessionID: String? = nil,
        createdAt: Date = .now,
        note: String
    ) {
        self.id = id
        self.userID = userID
        self.kind = kind
        self.amount = amount
        self.sessionID = sessionID
        self.createdAt = createdAt
        self.note = note
    }
}
