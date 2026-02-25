import Foundation
import SharedModels

@MainActor
public final class MockNotificationService: NotificationServiceProtocol {
    private var notifications: [AppNotification]

    public init() {
        self.notifications = [
            AppNotification(
                id: "notif-001",
                type: .taskAssigned,
                title: "Task Assigned",
                body: "You've been assigned to 'Home Inspection Walkthrough' by Michael Rodriguez.",
                isRead: false,
                createdAt: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!,
                relatedTaskId: "task-003"
            ),
            AppNotification(
                id: "notif-002",
                type: .newMessage,
                title: "New Message",
                body: "Michael Rodriguez sent you a message about the inspection.",
                isRead: false,
                createdAt: Calendar.current.date(byAdding: .hour, value: -1, to: Date())!,
                relatedTaskId: "task-003"
            ),
            AppNotification(
                id: "notif-003",
                type: .paymentReceived,
                title: "Payment Received",
                body: "You received $75.00 for 'Deliver Flyers to Neighborhood'.",
                isRead: true,
                createdAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                relatedTaskId: "task-006"
            ),
            AppNotification(
                id: "notif-004",
                type: .reviewReceived,
                title: "New Review",
                body: "Emily Johnson left you a 5-star review.",
                isRead: true,
                createdAt: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                relatedTaskId: "task-006"
            ),
            AppNotification(
                id: "notif-005",
                type: .taskCompleted,
                title: "Task Completed",
                body: "Michael Rodriguez marked 'Showing for Buyer Client' as completed.",
                isRead: false,
                createdAt: Calendar.current.date(byAdding: .hour, value: -5, to: Date())!,
                relatedTaskId: "task-007"
            ),
            AppNotification(
                id: "notif-006",
                type: .taskCancelled,
                title: "Task Cancelled",
                body: "A task you were watching has been cancelled by the poster.",
                isRead: true,
                createdAt: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                relatedTaskId: nil
            )
        ]
    }

    nonisolated public func fetchNotifications() async throws -> [AppNotification] {
        try await Task.sleep(for: .milliseconds(300))
        let allNotifications = await MainActor.run { self.notifications }
        return allNotifications.sorted { $0.createdAt > $1.createdAt }
    }

    nonisolated public func markAsRead(notificationId: String) async throws {
        try await Task.sleep(for: .milliseconds(300))
        await MainActor.run {
            if let index = self.notifications.firstIndex(where: { $0.id == notificationId }) {
                self.notifications[index].isRead = true
            }
        }
    }

    nonisolated public func unreadCount() async throws -> Int {
        try await Task.sleep(for: .milliseconds(300))
        let allNotifications = await MainActor.run { self.notifications }
        return allNotifications.filter { !$0.isRead }.count
    }
}
