import SwiftUI
import SharedModels
import Networking
import DesignSystem

/// Displays a list of conversations sorted by most recent activity.
public struct ConversationListView: View {

    // MARK: - Properties

    @Bindable var viewModel: ConversationListViewModel
    let messageService: MessageServiceProtocol
    let currentUser: User

    // MARK: - Init

    public init(
        viewModel: ConversationListViewModel,
        messageService: MessageServiceProtocol,
        currentUser: User
    ) {
        self.viewModel = viewModel
        self.messageService = messageService
        self.currentUser = currentUser
    }

    // MARK: - Body

    public var body: some View {
        Group {
            if viewModel.isLoading && viewModel.conversations.isEmpty {
                LoadingView(message: "Loading conversations...")
            } else if viewModel.conversations.isEmpty {
                EmptyStateView(
                    icon: "bubble.left.and.bubble.right",
                    title: "No Messages",
                    message: "Start a conversation by accepting a task or reaching out to another agent."
                )
            } else {
                conversationList
            }
        }
        .navigationTitle("Messages")
        .refreshable {
            viewModel.loadConversations()
        }
    }

    // MARK: - Subviews

    private var conversationList: some View {
        List(viewModel.conversations) { conversation in
            NavigationLink {
                ChatView(
                    viewModel: ChatViewModel(
                        messageService: messageService,
                        conversation: conversation,
                        currentUser: currentUser
                    )
                )
            } label: {
                conversationRow(conversation)
            }
            .listRowInsets(EdgeInsets(
                top: AppSpacing.sm,
                leading: AppSpacing.md,
                bottom: AppSpacing.sm,
                trailing: AppSpacing.md
            ))
        }
        .listStyle(.plain)
    }

    private func conversationRow(_ conversation: Conversation) -> some View {
        let otherParticipant = conversation.participants.first { $0.id != currentUser.id }
            ?? conversation.participants.first

        return HStack(spacing: AppSpacing.sm) {
            AvatarView(
                url: otherParticipant?.avatarURL,
                size: 52,
                showBadge: otherParticipant?.isVerified ?? false
            )

            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                HStack {
                    Text(otherParticipant?.fullName ?? "Unknown")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(AppColors.deepNavy)
                        .lineLimit(1)

                    Spacer()

                    Text(timeAgo(conversation.lastMessageAt))
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(AppColors.softGray)
                }

                if let taskTitle = conversation.taskTitle {
                    Text(taskTitle)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(AppColors.warmCoral)
                        .lineLimit(1)
                }

                HStack {
                    Text(conversation.lastMessage)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(AppColors.softGray)
                        .lineLimit(1)

                    Spacer()

                    if conversation.unreadCount > 0 {
                        unreadBadge(conversation.unreadCount)
                    }
                }
            }
        }
        .padding(.vertical, AppSpacing.xxs)
    }

    private func unreadBadge(_ count: Int) -> some View {
        Text("\(count)")
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(.white)
            .frame(minWidth: 22, minHeight: 22)
            .background(AppColors.warmCoral)
            .clipShape(Circle())
    }

    // MARK: - Helpers

    private func timeAgo(_ date: Date) -> String {
        let interval = Date().timeIntervalSince(date)

        if interval < 60 {
            return "Just now"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes)m ago"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return "\(hours)h ago"
        } else if interval < 604800 {
            let days = Int(interval / 86400)
            return "\(days)d ago"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: date)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ConversationListView(
            viewModel: {
                let vm = ConversationListViewModel(messageService: MockMessageService())
                vm.loadConversations()
                return vm
            }(),
            messageService: MockMessageService(),
            currentUser: SharedModels.MockUsers.currentUser
        )
    }
}
