import Testing
import Foundation
@testable import Notifications
import SharedModels
import Networking

// MARK: - Synchronous Mock Notification Service

struct SyncMockNotificationService: NotificationServiceProtocol {
    var notificationsToReturn: [AppNotification] = []
    private(set) var markedAsReadIds: [String] = []

    func fetchNotifications() async throws -> [AppNotification] {
        return notificationsToReturn.sorted { $0.createdAt > $1.createdAt }
    }

    mutating func markAsRead(notificationId: String) async throws {
        markedAsReadIds.append(notificationId)
    }

    func unreadCount() async throws -> Int {
        return notificationsToReturn.filter { !$0.isRead }.count
    }
}

// MARK: - Test Data

private enum TestData {
    static let notifications: [AppNotification] = [
        AppNotification(
            id: "notif-test-001",
            type: .taskAssigned,
            title: "Task Assigned",
            body: "You've been assigned to the open house.",
            isRead: false,
            createdAt: Calendar.current.date(byAdding: .hour, value: -1, to: Date())!,
            relatedTaskId: "task-001"
        ),
        AppNotification(
            id: "notif-test-002",
            type: .newMessage,
            title: "New Message",
            body: "Sarah sent you a message about the photography session.",
            isRead: false,
            createdAt: Calendar.current.date(byAdding: .hour, value: -3, to: Date())!,
            relatedTaskId: "task-002"
        ),
        AppNotification(
            id: "notif-test-003",
            type: .paymentReceived,
            title: "Payment Received",
            body: "You received $150.00 for the inspection walkthrough.",
            isRead: true,
            createdAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            relatedTaskId: "task-003"
        ),
        AppNotification(
            id: "notif-test-004",
            type: .reviewReceived,
            title: "New Review",
            body: "Marcus left you a 5-star review.",
            isRead: true,
            createdAt: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            relatedTaskId: "task-004"
        ),
        AppNotification(
            id: "notif-test-005",
            type: .taskCompleted,
            title: "Task Completed",
            body: "The photography task has been marked as completed.",
            isRead: false,
            createdAt: Calendar.current.date(byAdding: .hour, value: -5, to: Date())!,
            relatedTaskId: "task-005"
        )
    ]
}

// MARK: - Tests

@Suite("NotificationViewModel Tests")
struct NotificationViewModelTests {

    // MARK: - Load Tests

    @Test("loadNotifications populates notifications and unread count")
    @MainActor
    func loadNotifications() async {
        let service = SyncMockNotificationService(
            notificationsToReturn: TestData.notifications
        )
        let vm = NotificationViewModel(notificationService: service)

        #expect(vm.notifications.isEmpty)
        #expect(vm.unreadCount == 0)

        vm.loadNotifications()

        try? await Task.sleep(for: .milliseconds(100))

        #expect(vm.notifications.count == 5)
        #expect(vm.unreadCount == 3) // 3 unread notifications
        #expect(vm.isLoading == false)
    }

    @Test("loadNotifications returns sorted by date descending")
    @MainActor
    func loadNotificationsSorted() async {
        let service = SyncMockNotificationService(
            notificationsToReturn: TestData.notifications
        )
        let vm = NotificationViewModel(notificationService: service)

        vm.loadNotifications()

        try? await Task.sleep(for: .milliseconds(100))

        // Verify sorted by createdAt descending
        for i in 0..<(vm.notifications.count - 1) {
            #expect(vm.notifications[i].createdAt >= vm.notifications[i + 1].createdAt)
        }
    }

    // MARK: - Mark As Read Tests

    @Test("markAsRead decrements unread count")
    @MainActor
    func markAsRead() async {
        let service = SyncMockNotificationService(
            notificationsToReturn: TestData.notifications
        )
        let vm = NotificationViewModel(notificationService: service)

        vm.loadNotifications()
        try? await Task.sleep(for: .milliseconds(100))

        let initialUnread = vm.unreadCount
        #expect(initialUnread == 3)

        // Mark an unread notification as read
        vm.markAsRead(id: "notif-test-001")
        try? await Task.sleep(for: .milliseconds(100))

        #expect(vm.unreadCount == initialUnread - 1)

        // Verify the notification is now marked as read
        let notification = vm.notifications.first { $0.id == "notif-test-001" }
        #expect(notification?.isRead == true)
    }

    @Test("markAsRead on already-read notification does not change count")
    @MainActor
    func markAlreadyReadAsRead() async {
        let service = SyncMockNotificationService(
            notificationsToReturn: TestData.notifications
        )
        let vm = NotificationViewModel(notificationService: service)

        vm.loadNotifications()
        try? await Task.sleep(for: .milliseconds(100))

        let initialUnread = vm.unreadCount

        // notif-test-003 is already read
        vm.markAsRead(id: "notif-test-003")
        try? await Task.sleep(for: .milliseconds(100))

        #expect(vm.unreadCount == initialUnread)
    }

    // MARK: - Mark All As Read Tests

    @Test("markAllAsRead sets unread count to zero")
    @MainActor
    func markAllAsRead() async {
        let service = SyncMockNotificationService(
            notificationsToReturn: TestData.notifications
        )
        let vm = NotificationViewModel(notificationService: service)

        vm.loadNotifications()
        try? await Task.sleep(for: .milliseconds(100))

        #expect(vm.unreadCount == 3)

        vm.markAllAsRead()
        try? await Task.sleep(for: .milliseconds(200))

        #expect(vm.unreadCount == 0)
        #expect(vm.notifications.allSatisfy { $0.isRead })
    }

    // MARK: - Initial State Tests

    @Test("Initial state has empty notifications and zero unread")
    func initialState() {
        let service = SyncMockNotificationService()
        let vm = NotificationViewModel(notificationService: service)

        #expect(vm.notifications.isEmpty)
        #expect(vm.isLoading == false)
        #expect(vm.unreadCount == 0)
        #expect(vm.errorMessage == nil)
    }

    // MARK: - Empty State Tests

    @Test("loadNotifications with empty service returns empty array")
    @MainActor
    func loadEmptyNotifications() async {
        let service = SyncMockNotificationService(notificationsToReturn: [])
        let vm = NotificationViewModel(notificationService: service)

        vm.loadNotifications()
        try? await Task.sleep(for: .milliseconds(100))

        #expect(vm.notifications.isEmpty)
        #expect(vm.unreadCount == 0)
        #expect(vm.isLoading == false)
    }
}
