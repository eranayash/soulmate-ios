import Foundation
import Combine

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var draft = ""
    @Published private(set) var messages: [ChatMessage] = []

    private var replyTask: Task<Void, Never>?

    func bind(session: ChatSession?) {
        messages = session?.messages ?? []
    }

    func send(using coordinator: AppCoordinator) {
        let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty,
              let user = coordinator.sessionManager.currentUser,
              let session = coordinator.sessionManager.activeSession else { return }

        let outgoing = coordinator.chatService.sendMessage(trimmed, session: session, from: user)
        coordinator.sessionManager.appendMessage(outgoing)
        messages = coordinator.sessionManager.activeSession?.messages ?? []
        draft = ""

        replyTask?.cancel()
        replyTask = Task {
            try? await Task.sleep(nanoseconds: 900_000_000)
            guard !Task.isCancelled,
                  let active = coordinator.sessionManager.activeSession else { return }
            let reply = coordinator.chatService.mockReply(for: active)
            coordinator.sessionManager.appendMessage(reply)
            messages = coordinator.sessionManager.activeSession?.messages ?? []
        }
    }

    func endChat(using coordinator: AppCoordinator) {
        replyTask?.cancel()
        coordinator.returnToDashboard()
    }
}
