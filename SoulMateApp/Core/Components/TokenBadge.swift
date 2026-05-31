import SwiftUI

struct TokenBadge: View {
    let balance: Int
    var compact: Bool = false

    var body: some View {
        HStack(spacing: compact ? 6 : 8) {
            Image(systemName: "bolt.fill")
                .font(.system(size: compact ? 12 : 14, weight: .bold))
                .foregroundStyle(AppColors.accentGold)

            Text("\(balance)")
                .font(compact ? AppFonts.caption(14) : AppFonts.headline(16))
                .foregroundStyle(AppColors.textPrimary)

            if !compact {
                Text("tokens")
                    .font(AppFonts.caption())
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .padding(.horizontal, compact ? 12 : 16)
        .padding(.vertical, compact ? 8 : 10)
        .background(AppColors.tokenGradient.opacity(0.18))
        .overlay {
            Capsule()
                .stroke(AppColors.tokenGradient.opacity(0.45), lineWidth: 1)
        }
        .clipShape(Capsule())
    }
}
