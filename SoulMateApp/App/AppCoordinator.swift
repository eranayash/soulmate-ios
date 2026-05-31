import SwiftUI

enum AppRoute: Hashable {
    case onboarding
    case dashboard
    case chat(sessionID: String)
    case wallet
}

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var route: AppRoute = .onboarding
    @Published var selectedMood: Mood?
    @Published var selectedPenpal: PenpalProfile?

    let sessionManager = SessionManager.shared
    let tokenEconomy = TokenEconomyService.shared
    let chatService = ChatService.shared

    func completeOnboarding(role: UserRole) {
        sessionManager.signIn(role: role)
        route = .dashboard
    }

    func openWallet() {
        route = .wallet
    }

    func returnToDashboard() {
        tokenEconomy.stop()
        sessionManager.endSession()
        route = .dashboard
    }

    func startChat(with penpal: PenpalProfile, mood: Mood) {
        guard let user = sessionManager.currentUser else { return }
        guard sessionManager.canStartChat() else {
            route = .wallet
            return
        }

        selectedPenpal = penpal
        selectedMood = mood

        let session = chatService.createSession(seeker: user, penpal: penpal, mood: mood)
        sessionManager.startSession(session)

        tokenEconomy.onEvent = { [weak self] event in
            self?.handleTokenEvent(event, sessionID: session.id)
        }
        tokenEconomy.start(
            sessionID: session.id,
            initialChunksAvailable: user.tokenBalance
        )

        route = .chat(sessionID: session.id)
    }

    private func handleTokenEvent(_ event: TokenEconomyEvent, sessionID: String) {
        switch event {
        case .chunkStarted:
            break
        case .chunkCompleted:
            if sessionManager.currentUser?.role == .seeker {
                let paid = sessionManager.chargeChunk(for: sessionID)
                tokenEconomy.handleChunkPaid(success: paid)
                if !paid {
                    sessionManager.endSession(status: .insufficientTokens)
                }
            } else {
                sessionManager.creditPenpal(for: sessionID)
                tokenEconomy.handleChunkPaid(success: true)
            }
        case .insufficientTokens:
            sessionManager.endSession(status: .insufficientTokens)
        case .sessionEnded:
            sessionManager.endSession(status: .insufficientTokens)
            route = .wallet
        }
    }
}
