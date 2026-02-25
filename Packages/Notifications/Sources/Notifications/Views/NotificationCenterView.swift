import SwiftUI
import SharedModels
import Networking
import DesignSystem

/// Displays a list of notifications with unread indicators and swipe actions.
public struct NotificationCenterView: View {

    // MARK: - Properties

    @Bindable var viewModel: NotificationViewModel

    // MARK: - Init

    public init(viewModel: NotificationViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    public var body: some View {
        Group {
            if viewModel.isLoading && viewModel.notifications.isEmpty {
                LoadingView(message: "Loading notifications...")
            } else if viewModel.notifications.isEmpty {
                EmptyStateView(
                    icon: "bell.slash",
                    title: "No Notifications",
                    message: "You're all caught up! Notifications about tasks, messages, and payments will appear here."
                )
            } else {
                notificationList
            }
        }
        .navigationTitle("Notifications")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.unreadCount > 0 {
                    Button("Mark All Read") {
                        viewModel.markAllAsRead()
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColors.warmCoral)
                }
            }
        }
        .refreshable {
            viewModel.loadNotifications()
        }
    }

    // MARK: - Notification List

    private var notificationList: some View {
        List {
            ForEach(viewModel.notifications) { notification in
                notificationRow(notification)
                    .listRowInsets(EdgeInsets(
                        top: AppSpacing.xxs,
                        leading: 0,
                        bottom: AppSpacing.xxs,
                        trailing: 0
                    ))
                    .listRowBackground(
                        notification.isRead
                            ? Color.clear
                            : AppColors.warmCoral.opacity(0.05)
                    )
                    .swipeActions(edge: .trailing) {
                        if !notification.isRead {
                            Button {
                                viewModel.markAsRead(id: notification.id)
                            } label: {
                                Label("Read", systemImage: "envelope.open")
                            }
                            .tint(AppColors.deepNavy)
                        }
                    }
            }
        }
        .listStyle(.plain)
    }

    // MARK: - Notification Row

    private func notificationRow(_ notification: AppNotification) -> some View {
        HStack(alignment: .top, spacing: AppSpacing.sm) {
            notificationIcon(notification.type)

            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                HStack {
                    Text(notification.title)
                        .font(.system(size: 15, weight: notification.isRead ? .medium : .bold))
                        .foregroundStyle(AppColors.deepNavy)

                    Spacer()

                    Text(timeAgo(notification.createdAt))
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(AppColors.softGray)
                }

                Text(notification.body)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(AppColors.softGray)
                    .lineLimit(3)
                    .lineSpacing(2)
            }

            if !notification.isRead {
                Circle()
                    .fill(AppColors.warmCoral)
                    .frame(width: 8, height: 8)
                    .padding(.top, AppSpacing.xxs + 2)
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .contentShape(Rectangle())
        .onTapGesture {
            if !notification.isRead {
                viewModel.markAsRead(id: notification.id)
            }
        }
    }

    // MARK: - Notification Icon

    private func notificationIcon(_ type: NotificationType) -> some View {
        let config = iconConfig(for: type)

        return Image(systemName: config.iconName)
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(config.color)
            .frame(width: 40, height: 40)
            .background(config.color.opacity(0.12))
            .clipShape(Circle())
    }

    private struct IconConfig {
        let iconName: String
        let color: Color
    }

    private func iconConfig(for type: NotificationType) -> IconConfig {
        switch type {
        case .taskAssigned:
            return IconConfig(iconName: "briefcase.fill", color: AppColors.deepNavy)
        case .taskCompleted:
            return IconConfig(iconName: "checkmark.circle.fill", color: AppColors.successGreen)
        case .newMessage:
            return IconConfig(iconName: "bubble.left.fill", color: .blue)
        case .paymentReceived:
            return IconConfig(iconName: "dollarsign.circle.fill", color: AppColors.successGreen)
        case .reviewReceived:
            return IconConfig(iconName: "star.fill", color: AppColors.accentGold)
        case .taskCancelled:
            return IconConfig(iconName: "xmark.circle.fill", color: AppColors.errorRed)
        }
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
        NotificationCenterView(
            viewModel: {
                let vm = NotificationViewModel(notificationService: MockNotificationService())
                vm.loadNotifications()
                return vm
            }()
        )
    }
}
