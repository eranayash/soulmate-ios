import SwiftUI

struct CustomButton: View {
    enum Style {
        case primary
        case secondary
        case ghost
    }

    let title: String
    var icon: String? = nil
    var style: Style = .primary
    var isEnabled: Bool = true
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .bold))
                }
                Text(title)
                    .font(AppFonts.headline())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .foregroundStyle(foregroundColor)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(borderColor, lineWidth: style == .ghost ? 1.5 : 0)
            }
            .scaleEffect(isPressed ? 0.96 : 1)
            .shadow(color: shadowColor, radius: isPressed ? 4 : 12, y: isPressed ? 2 : 8)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.5)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.55)) {
                        isPressed = false
                    }
                }
        )
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isEnabled)
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .primary:
            AppColors.heroGradient
        case .secondary:
            AppColors.cardGradient
        case .ghost:
            Color.clear
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary: return AppColors.background
        case .secondary, .ghost: return AppColors.textPrimary
        }
    }

    private var borderColor: Color {
        AppColors.textMuted.opacity(0.35)
    }

    private var shadowColor: Color {
        style == .primary ? AppColors.accentGreen.opacity(0.35) : .clear
    }
}
