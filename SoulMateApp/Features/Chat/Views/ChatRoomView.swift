import SwiftUI

struct ChatRoomView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel = ChatViewModel()

    private var session: ChatSession? { coordinator.sessionManager.activeSession }
    private var user: User? { coordinator.sessionManager.currentUser }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            messagesList
            composer
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
        .onAppear {
            viewModel.bind(session: session)
        }
        .onChange(of: coordinator.sessionManager.activeSession?.messages.count) { _, _ in
            viewModel.bind(session: coordinator.sessionManager.activeSession)
        }
    }

    private var topBar: some View {
        VStack(spacing: 12) {
            HStack {
                Button {
                    viewModel.endChat(using: coordinator)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundStyle(AppColors.textPrimary)
                        .padding(10)
                        .background(AppColors.surface)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 2) {
                    Text(session?.penpalName ?? "Chat")
                        .font(AppFonts.headline())
                        .foregroundStyle(AppColors.textPrimary)
                    if let mood = session?.mood {
                        Text("\(mood.emoji) \(mood.label)")
                            .font(AppFonts.caption())
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }

                Spacer()
            }

            if user?.role == .seeker {
                TimerOverlayView(
                    tokenEconomy: coordinator.tokenEconomy,
                    tokenBalance: user?.tokenBalance ?? 0
                )
            }
        }
        .padding(.vertical, 12)
    }

    private var messagesList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.messages) { message in
                        MessageBubble(message: message)
                            .id(message.id)
                    }
                }
                .padding(.vertical, 8)
            }
            .onChange(of: viewModel.messages.count) { _, _ in
                if let last = viewModel.messages.last?.id {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        proxy.scrollTo(last, anchor: .bottom)
                    }
                }
            }
        }
    }

    private var composer: some View {
        HStack(spacing: 10) {
            TextField("Say something...", text: $viewModel.draft, axis: .vertical)
                .font(AppFonts.body())
                .padding(12)
                .background(AppColors.surface)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .foregroundStyle(AppColors.textPrimary)

            Button {
                viewModel.send(using: coordinator)
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(AppColors.background)
                    .padding(14)
                    .background(AppColors.heroGradient)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .disabled(viewModel.draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.top, 8)
    }
}

private struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isFromCurrentUser { Spacer(minLength: 40) }

            Text(message.text)
                .font(AppFonts.body(15))
                .foregroundStyle(message.isFromCurrentUser ? AppColors.background : AppColors.textPrimary)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(message.isFromCurrentUser ? AnyShapeStyle(AppColors.heroGradient) : AnyShapeStyle(AppColors.surfaceElevated))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            if !message.isFromCurrentUser { Spacer(minLength: 40) }
        }
    }
}
