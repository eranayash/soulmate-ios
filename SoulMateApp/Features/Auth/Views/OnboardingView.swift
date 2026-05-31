import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @State private var selectedRole: UserRole?

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            VStack(spacing: 12) {
                Text("Soul Mate")
                    .font(AppFonts.display(40))
                    .foregroundStyle(AppColors.heroGradient)

                Text("Anonymous peer support.\nOne tap to connect.")
                    .font(AppFonts.body())
                    .multilineTextAlignment(.center)
                    .foregroundStyle(AppColors.textSecondary)
            }

            VStack(spacing: 14) {
                ForEach(UserRole.allCases) { role in
                    RoleCard(role: role, isSelected: selectedRole == role) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            selectedRole = role
                        }
                    }
                }
            }

            CustomButton(
                title: "Continue",
                icon: "arrow.right",
                isEnabled: selectedRole != nil
            ) {
                guard let selectedRole else { return }
                coordinator.completeOnboarding(role: selectedRole)
            }

            Text("Not therapy. For casual emotional support only.")
                .font(AppFonts.caption())
                .foregroundStyle(AppColors.textMuted)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding(24)
    }
}

private struct RoleCard: View {
    let role: UserRole
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(role.displayName)
                        .font(AppFonts.headline())
                        .foregroundStyle(AppColors.textPrimary)
                    Text(role.subtitle)
                        .font(AppFonts.caption())
                        .foregroundStyle(AppColors.textSecondary)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? AppColors.accentGreen : AppColors.textMuted)
                    .font(.title2)
            }
            .padding(18)
            .background(AppColors.cardGradient)
            .overlay {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(isSelected ? AppColors.accentGreen.opacity(0.8) : Color.clear, lineWidth: 2)
            }
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .scaleEffect(isSelected ? 1.02 : 1)
        }
        .buttonStyle(.plain)
    }
}
