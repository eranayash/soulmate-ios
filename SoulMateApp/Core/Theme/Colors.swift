import SwiftUI

enum AppColors {
    static let background = Color(red: 0.06, green: 0.07, blue: 0.12)
    static let surface = Color(red: 0.12, green: 0.14, blue: 0.22)
    static let surfaceElevated = Color(red: 0.16, green: 0.18, blue: 0.28)

    static let accentGreen = Color(red: 0.20, green: 0.85, blue: 0.55)
    static let accentPurple = Color(red: 0.55, green: 0.35, blue: 0.95)
    static let accentPink = Color(red: 0.95, green: 0.35, blue: 0.65)
    static let accentGold = Color(red: 1.0, green: 0.78, blue: 0.25)

    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.72)
    static let textMuted = Color.white.opacity(0.45)

    static let danger = Color(red: 1.0, green: 0.35, blue: 0.40)
    static let success = accentGreen

    static var heroGradient: LinearGradient {
        LinearGradient(
            colors: [accentGreen, accentPurple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var cardGradient: LinearGradient {
        LinearGradient(
            colors: [surfaceElevated, surface],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var tokenGradient: LinearGradient {
        LinearGradient(
            colors: [accentGold, accentPink],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
