import Foundation
import Combine

@MainActor
final class SessionManager: ObservableObject {
    static let shared = SessionManager()

    @Published private(set) var currentUser: User?
    @Published private(set) var activeSession: ChatSession?
    @Published private(set) var transactions: [TokenTransaction] = []

    private init() {}

    func signIn(role: UserRole) {
        currentUser = User.anonymous(role: role)
        if role == .seeker {
            recordTransaction(
                kind: .welcomeBonus,
                amount: 3,
                note: "Welcome bonus"
            )
        }
    }

    func signOut() {
        endSession()
        currentUser = nil
        transactions = []
    }

    func setAvailability(_ available: Bool) {
        currentUser?.isAvailable = available
    }

    func canStartChat() -> Bool {
        guard let user = currentUser, user.role == .seeker else { return true }
        return user.tokenBalance > 0
    }

    func startSession(_ session: ChatSession) {
        activeSession = session
    }

    func appendMessage(_ message: ChatMessage) {
        guard var session = activeSession else { return }
        session.messages.append(message)
        activeSession = session
    }

    func endSession(status: ChatSessionStatus = .ended) {
        guard var session = activeSession else { return }
        session.status = status
        activeSession = session.status == .ended ? nil : session
        if status == .ended || status == .insufficientTokens {
            activeSession = nil
        }
    }

    @discardableResult
    func chargeChunk(for sessionID: String) -> Bool {
        guard var user = currentUser, user.role == .seeker else { return true }
        guard user.tokenBalance > 0 else { return false }

        user.tokenBalance -= 1
        currentUser = user
        recordTransaction(
            kind: .chatChunkDebit,
            amount: -1,
            sessionID: sessionID,
            note: "6-minute connection"
        )
        return true
    }

    func creditPenpal(for sessionID: String) {
        guard var user = currentUser, user.role == .penpal else { return }
        user.tokenBalance += 1
        currentUser = user
        recordTransaction(
            kind: .chatChunkCredit,
            amount: 1,
            sessionID: sessionID,
            note: "Listening reward"
        )
    }

    func topUp(amount: Int) {
        guard var user = currentUser else { return }
        user.tokenBalance += amount
        currentUser = user
        recordTransaction(kind: .topUp, amount: amount, note: "Mock top-up")
    }

    private func recordTransaction(
        kind: TokenTransactionKind,
        amount: Int,
        sessionID: String? = nil,
        note: String
    ) {
        guard let user = currentUser else { return }
        let tx = TokenTransaction(userID: user.id, kind: kind, amount: amount, sessionID: sessionID, note: note)
        transactions.insert(tx, at: 0)
    }
}
