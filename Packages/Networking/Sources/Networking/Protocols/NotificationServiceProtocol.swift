import SharedModels

public protocol NotificationServiceProtocol: Sendable {
    func fetchNotifications() async throws -> [AppNotification]
    func markAsRead(notificationId: String) async throws
    func unreadCount() async throws -> Int
}
