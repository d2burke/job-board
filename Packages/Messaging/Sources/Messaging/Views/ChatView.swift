import SwiftUI
import SharedModels
import Networking
import DesignSystem

/// Displays a chat thread between the current user and another participant.
public struct ChatView: View {

    // MARK: - Properties

    @Bindable var viewModel: ChatViewModel

    // MARK: - Init

    public init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            messageList
            Divider()
            inputBar
        }
        .navigationTitle(otherParticipantName)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.loadMessages()
            viewModel.markAsRead()
        }
    }

    // MARK: - Computed

    private var otherParticipantName: String {
        let other = viewModel.conversation.participants.first { $0.id != viewModel.currentUserId }
        return other?.fullName ?? "Chat"
    }

    // MARK: - Message List

    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: AppSpacing.xs) {
                    ForEach(viewModel.messages) { message in
                        messageBubble(message)
                            .id(message.id)
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
            }
            .onChange(of: viewModel.messages.count) { _, _ in
                scrollToBottom(proxy: proxy)
            }
            .onAppear {
                scrollToBottom(proxy: proxy)
            }
        }
        .background(AppColors.freshWhite)
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastMessage = viewModel.messages.last {
            withAnimation(.easeOut(duration: 0.2)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }

    // MARK: - Message Bubble

    private func messageBubble(_ message: Message) -> some View {
        let isCurrentUser = message.senderId == viewModel.currentUserId

        return HStack(alignment: .bottom, spacing: AppSpacing.xs) {
            if isCurrentUser { Spacer(minLength: AppSpacing.xxl) }

            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: AppSpacing.xxxs) {
                Text(message.text)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(isCurrentUser ? .white : AppColors.deepNavy)
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical, AppSpacing.xs + 2)
                    .background(isCurrentUser ? AppColors.warmCoral : AppColors.lightGray)
                    .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.medium))

                Text(formatTime(message.timestamp))
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(AppColors.softGray)
                    .padding(.horizontal, AppSpacing.xxs)
            }

            if !isCurrentUser { Spacer(minLength: AppSpacing.xxl) }
        }
    }

    // MARK: - Input Bar

    private var inputBar: some View {
        HStack(spacing: AppSpacing.sm) {
            TextField("Type a message...", text: $viewModel.messageText, axis: .vertical)
                .font(.system(size: 16))
                .foregroundStyle(AppColors.deepNavy)
                .padding(.horizontal, AppSpacing.sm)
                .padding(.vertical, AppSpacing.xs)
                .background(AppColors.lightGray)
                .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.pill))
                .lineLimit(1...5)

            Button {
                viewModel.sendMessage()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 34))
                    .foregroundStyle(
                        viewModel.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            ? AppColors.softGray
                            : AppColors.warmCoral
                    )
            }
            .disabled(viewModel.messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.xs)
        .background(.white)
    }

    // MARK: - Helpers

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            formatter.dateFormat = "h:mm a"
        } else if calendar.isDateInYesterday(date) {
            formatter.dateFormat = "'Yesterday' h:mm a"
        } else {
            formatter.dateFormat = "MMM d, h:mm a"
        }

        return formatter.string(from: date)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ChatView(
            viewModel: {
                let conversation = Conversation(
                    id: "conv-001",
                    participants: [SharedModels.MockUsers.currentUser, SharedModels.MockUsers.sarah],
                    lastMessage: "Let me know if you have any questions before Saturday.",
                    lastMessageAt: Date(),
                    unreadCount: 0,
                    taskTitle: "Open House at 1204 Elm Creek"
                )
                let vm = ChatViewModel(
                    messageService: MockMessageService(),
                    conversation: conversation,
                    currentUser: SharedModels.MockUsers.currentUser
                )
                vm.loadMessages()
                return vm
            }()
        )
    }
}
