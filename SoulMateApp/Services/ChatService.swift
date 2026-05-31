import Foundation

@MainActor
final class ChatService {
    static let shared = ChatService()

    private init() {}

    func mockPenpals(for mood: Mood?) -> [PenpalProfile] {
        let all: [PenpalProfile] = [
            PenpalProfile(id: "p1", name: "River", tagline: "Calm listener, night owl", moods: [.anxious, .lonely, .reflective], rating: 4.9, isOnline: true),
            PenpalProfile(id: "p2", name: "Sage", tagline: "Warm vibes only", moods: [.stressed, .grateful], rating: 4.8, isOnline: true),
            PenpalProfile(id: "p3", name: "Nova", tagline: "Here for the big feelings", moods: [.excited, .anxious, .stressed], rating: 4.7, isOnline: true),
            PenpalProfile(id: "p4", name: "Echo", tagline: "Soft space to unpack", moods: [.lonely, .reflective], rating: 4.9, isOnline: false),
            PenpalProfile(id: "p5", name: "Bloom", tagline: "Celebrating small wins", moods: [.grateful, .excited], rating: 4.6, isOnline: true)
        ]

        guard let mood else { return all.filter(\.isOnline) }
        return all.filter { $0.isOnline && $0.moods.contains(mood) }
    }

    func createSession(seeker: User, penpal: PenpalProfile, mood: Mood) -> ChatSession {
        ChatSession(
            seekerID: seeker.id,
            penpalID: penpal.id,
            penpalName: penpal.name,
            mood: mood,
            messages: [
                ChatMessage(
                    senderID: penpal.id,
                    text: "Hey \(seeker.displayName) 👋 I'm \(penpal.name). What's on your mind?",
                    isFromCurrentUser: false
                )
            ]
        )
    }

    func sendMessage(_ text: String, session: ChatSession, from user: User) -> ChatMessage {
        ChatMessage(senderID: user.id, text: text, isFromCurrentUser: true)
    }

    func mockReply(for session: ChatSession) -> ChatMessage {
        let replies = [
            "I'm here with you.",
            "That sounds like a lot. Tell me more?",
            "You're not alone in this.",
            "Thanks for sharing that with me.",
            "How are you feeling in your body right now?"
        ]
        let text = replies.randomElement() ?? "I'm listening."
        return ChatMessage(senderID: session.penpalID, text: text, isFromCurrentUser: false)
    }
}
