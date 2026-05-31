import SwiftUI

struct WalletView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel = WalletViewModel()

    private var user: User? { coordinator.sessionManager.currentUser }
    private var transactions: [TokenTransaction] { coordinator.sessionManager.transactions }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                balanceCard
                topUpSection
                historySection
            }
            .padding(20)
        }
    }

    private var header: some View {
        HStack {
            Button {
                coordinator.returnToDashboard()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .foregroundStyle(AppColors.textPrimary)
            }
            .buttonStyle(.plain)

            Text("Wallet")
                .font(AppFonts.display(28))
                .foregroundStyle(AppColors.textPrimary)

            Spacer()
        }
    }

    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your balance")
                .font(AppFonts.caption())
                .foregroundStyle(AppColors.textSecondary)
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("\(user?.tokenBalance ?? 0)")
                    .font(AppFonts.display(44))
                    .foregroundStyle(AppColors.heroGradient)
                Text("tokens")
                    .font(AppFonts.headline())
                    .foregroundStyle(AppColors.textSecondary)
            }
            Text("1 token = 6 minutes of connection")
                .font(AppFonts.caption())
                .foregroundStyle(AppColors.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(22)
        .background(AppColors.cardGradient)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var topUpSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top up (mock)")
                .font(AppFonts.headline())
                .foregroundStyle(AppColors.textPrimary)

            HStack(spacing: 10) {
                ForEach([1, 3, 5], id: \.self) { amount in
                    Button {
                        viewModel.topUp(using: coordinator, amount: amount)
                    } label: {
                        Text("+\(amount)")
                            .font(AppFonts.headline())
                            .foregroundStyle(AppColors.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(AppColors.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }

            Text("StoreKit integration planned for Phase 2.")
                .font(AppFonts.caption())
                .foregroundStyle(AppColors.textMuted)
        }
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent activity")
                .font(AppFonts.headline())
                .foregroundStyle(AppColors.textPrimary)

            if transactions.isEmpty {
                Text("No transactions yet.")
                    .font(AppFonts.caption())
                    .foregroundStyle(AppColors.textMuted)
            } else {
                ForEach(transactions) { tx in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(tx.note)
                                .font(AppFonts.body(15))
                                .foregroundStyle(AppColors.textPrimary)
                            Text(tx.createdAt.formatted(date: .abbreviated, time: .shortened))
                                .font(AppFonts.caption())
                                .foregroundStyle(AppColors.textMuted)
                        }
                        Spacer()
                        Text(tx.amount >= 0 ? "+\(tx.amount)" : "\(tx.amount)")
                            .font(AppFonts.headline())
                            .foregroundStyle(tx.amount >= 0 ? AppColors.success : AppColors.danger)
                    }
                    .padding(14)
                    .background(AppColors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
        }
    }
}
