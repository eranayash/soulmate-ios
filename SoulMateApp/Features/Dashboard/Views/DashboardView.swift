import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel = DashboardViewModel()

    private var user: User? { coordinator.sessionManager.currentUser }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                if user?.role == .penpal {
                    penpalControls
                } else {
                    moodPicker
                    penpalDeck
                }
            }
            .padding(20)
        }
        .onAppear {
            viewModel.loadPenpals(using: coordinator.chatService)
        }
        .onChange(of: viewModel.selectedMood) { _, _ in
            viewModel.loadPenpals(using: coordinator.chatService)
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Hey, \(user?.displayName ?? "friend")")
                    .font(AppFonts.display(28))
                    .foregroundStyle(AppColors.textPrimary)
                Text(user?.role == .penpal ? "Ready to listen?" : "Pick a vibe. Tap to talk.")
                    .font(AppFonts.body())
                    .foregroundStyle(AppColors.textSecondary)
            }
            Spacer()
            Button {
                coordinator.openWallet()
            } label: {
                TokenBadge(balance: user?.tokenBalance ?? 0, compact: true)
            }
            .buttonStyle(.plain)
        }
    }

    private var moodPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What's your mood?")
                .font(AppFonts.headline())
                .foregroundStyle(AppColors.textPrimary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    MoodChip(mood: nil, label: "Any", isSelected: viewModel.selectedMood == nil) {
                        viewModel.selectedMood = nil
                    }
                    ForEach(Mood.allCases) { mood in
                        MoodChip(mood: mood, label: mood.label, isSelected: viewModel.selectedMood == mood) {
                            viewModel.selectedMood = mood
                        }
                    }
                }
            }
        }
    }

    private var penpalDeck: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Available Penpals")
                .font(AppFonts.headline())
                .foregroundStyle(AppColors.textPrimary)

            if viewModel.penpals.isEmpty {
                emptyState
            } else {
                ForEach(viewModel.penpals) { penpal in
                    PenpalCard(penpal: penpal) {
                        let mood = viewModel.selectedMood ?? penpal.moods.first ?? .reflective
                        coordinator.startChat(with: penpal, mood: mood)
                    }
                }
            }
        }
    }

    private var penpalControls: some View {
        VStack(spacing: 16) {
            HStack {
                Circle()
                    .fill((user?.isAvailable ?? false) ? AppColors.success : AppColors.textMuted)
                    .frame(width: 12, height: 12)
                Text((user?.isAvailable ?? false) ? "You're available" : "You're offline")
                    .font(AppFonts.headline())
                    .foregroundStyle(AppColors.textPrimary)
                Spacer()
            }
            .padding(18)
            .background(AppColors.cardGradient)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            CustomButton(
                title: (user?.isAvailable ?? false) ? "Go Offline" : "Go Available",
                icon: (user?.isAvailable ?? false) ? "moon.fill" : "sun.max.fill"
            ) {
                coordinator.sessionManager.setAvailability(!(user?.isAvailable ?? false))
            }

            Text("Incoming chat requests will appear here in Phase 2.")
                .font(AppFonts.caption())
                .foregroundStyle(AppColors.textMuted)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Text("No penpals online for this mood")
                .font(AppFonts.headline())
                .foregroundStyle(AppColors.textPrimary)
            Text("Try another vibe or check back soon.")
                .font(AppFonts.caption())
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(28)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct MoodChip: View {
    let mood: Mood?
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let mood {
                    Text(mood.emoji)
                }
                Text(label)
                    .font(AppFonts.caption())
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .foregroundStyle(isSelected ? AppColors.background : AppColors.textPrimary)
            .background(isSelected ? AnyShapeStyle(AppColors.heroGradient) : AnyShapeStyle(AppColors.surface))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

private struct PenpalCard: View {
    let penpal: PenpalProfile
    let onConnect: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(penpal.name)
                        .font(AppFonts.title(22))
                        .foregroundStyle(AppColors.textPrimary)
                    Text(penpal.tagline)
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                }
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(AppColors.accentGold)
                    Text(String(format: "%.1f", penpal.rating))
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textPrimary)
                }
            }

            HStack {
                ForEach(penpal.moods.prefix(3)) { mood in
                    Text(mood.emoji)
                }
                Spacer()
                CustomButton(title: "Talk", icon: "bubble.left.and.bubble.right.fill", style: .primary) {
                    onConnect()
                }
                .frame(width: 120)
            }
        }
        .padding(18)
        .background(AppColors.cardGradient)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}
