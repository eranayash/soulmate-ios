import Foundation

enum ChatSessionStatus: String, Codable {
    case pending
    case active
    case paused
    case ended
    case insufficientTokens
}

struct ChatMessage: Identifiable, Codable, Equatable {
    let id: String
    let senderID: String
    let text: String
    let sentAt: Date
    let isFromCurrentUser: Bool

    init(id: String = UUID().uuidString, senderID: String, text: String, sentAt: Date = .now, isFromCurrentUser: Bool) {
        self.id = id
        self.senderID = senderID
        self.text = text
        self.sentAt = sentAt
        self.isFromCurrentUser = isFromCurrentUser
    }
}

struct ChatSession: Identifiable, Codable, Equatable {
    let id: String
    let seekerID: String
    let penpalID: String
    let penpalName: String
    let mood: Mood
    var status: ChatSessionStatus
    let startedAt: Date
    var chunksConsumed: Int
    var messages: [ChatMessage]

    init(
        id: String = UUID().uuidString,
        seekerID: String,
        penpalID: String,
        penpalName: String,
        mood: Mood,
        status: ChatSessionStatus = .active,
        startedAt: Date = .now,
        chunksConsumed: Int = 0,
        messages: [ChatMessage] = []
    ) {
        self.id = id
        self.seekerID = seekerID
        self.penpalID = penpalID
        self.penpalName = penpalName
        self.mood = mood
        self.status = status
        self.startedAt = startedAt
        self.chunksConsumed = chunksConsumed
        self.messages = messages
    }
}
