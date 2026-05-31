import SwiftUI

struct TimerOverlayView: View {
    @ObservedObject var tokenEconomy: TokenEconomyService
    let tokenBalance: Int

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(tokenEconomy.isInGracePeriod ? "Grace period" : "Current chunk")
                    .font(AppFonts.caption())
                    .foregroundStyle(AppColors.textSecondary)
                Text(displayTime)
                    .font(AppFonts.mono(22))
                    .foregroundStyle(timerColor)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: displayTime)
            }

            Spacer()

            TokenBadge(balance: tokenBalance, compact: true)

            if tokenEconomy.isInGracePeriod {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(AppColors.danger)
            }
        }
        .padding(14)
        .background(AppColors.surfaceElevated.opacity(0.95))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(AppColors.tokenGradient.opacity(0.35), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var displayTime: String {
        if tokenEconomy.isInGracePeriod {
            return tokenEconomy.graceRemaining.chunkFormatted
        }
        return tokenEconomy.remainingSeconds.chunkFormatted
    }

    private var timerColor: Color {
        if tokenEconomy.isInGracePeriod { return AppColors.danger }
        if tokenEconomy.remainingSeconds <= 60 { return AppColors.accentGold }
        return AppColors.accentGreen
    }
}
