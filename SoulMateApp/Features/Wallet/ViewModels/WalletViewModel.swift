import SwiftUI

@MainActor
final class WalletViewModel: ObservableObject {
    @Published var isToppingUp = false

    func topUp(using coordinator: AppCoordinator, amount: Int) {
        isToppingUp = true
        coordinator.sessionManager.topUp(amount: amount)
        isToppingUp = false
    }
}
