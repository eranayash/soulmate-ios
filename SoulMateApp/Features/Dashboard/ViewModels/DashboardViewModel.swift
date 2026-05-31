import SwiftUI

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var selectedMood: Mood?
    @Published var penpals: [PenpalProfile] = []

    func loadPenpals(using service: ChatService) {
        penpals = service.mockPenpals(for: selectedMood)
    }
}
