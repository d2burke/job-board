import Foundation
import Observation
import SharedModels
import Networking

// MARK: - NotificationViewModel

@Observable
public final class NotificationViewModel {

    // MARK: - State

    public var notifications: [AppNotification] = []
    public var isLoading: Bool = false
    public var unreadCount: Int = 0
    public var errorMessage: String?

    // MARK: - Dependencies

    private let notificationService: NotificationServiceProtocol

    // MARK: - Init

    public init(notificationService: NotificationServiceProtocol) {
        self.notificationService = notificationService
    }

    // MARK: - Actions

    public func loadNotifications() {
        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            do {
                let fetched = try await notificationService.fetchNotifications()
                notifications = fetched
                unreadCount = fetched.filter { !$0.isRead }.count
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }

    public func markAsRead(id: String) {
        Task { @MainActor in
            do {
                try await notificationService.markAsRead(notificationId: id)
                if let index = notifications.firstIndex(where: { $0.id == id }) {
                    if !notifications[index].isRead {
                        notifications[index].isRead = true
                        unreadCount = max(0, unreadCount - 1)
                    }
                }
            } catch {
                // Silently fail — not critical for UX
            }
        }
    }

    public func markAllAsRead() {
        let unreadIds = notifications
            .filter { !$0.isRead }
            .map { $0.id }

        guard !unreadIds.isEmpty else { return }

        Task { @MainActor in
            for id in unreadIds {
                do {
                    try await notificationService.markAsRead(notificationId: id)
                    if let index = notifications.firstIndex(where: { $0.id == id }) {
                        notifications[index].isRead = true
                    }
                } catch {
                    // Continue marking remaining notifications
                }
            }
            unreadCount = 0
        }
    }
}
