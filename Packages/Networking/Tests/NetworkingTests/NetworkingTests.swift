import XCTest
@testable import Networking
import SharedModels

@MainActor
final class NetworkingTests: XCTestCase {

    // MARK: - MockAuthService Tests

    func testSignInReturnsNonNilUser() async throws {
        let authService = MockAuthService()
        let user = try await authService.signIn(email: "test@example.com", password: "password")
        XCTAssertNotNil(user)
        XCTAssertEqual(user.id, MockUsers.currentUser.id)
        XCTAssertEqual(user.firstName, "Sarah")
        XCTAssertEqual(user.lastName, "Chen")
    }

    func testSignOutClearsUser() async throws {
        let authService = MockAuthService()
        _ = try await authService.signIn(email: "test@example.com", password: "password")
        let userBeforeSignOut = await authService.currentUser()
        XCTAssertNotNil(userBeforeSignOut)

        try await authService.signOut()
        let userAfterSignOut = await authService.currentUser()
        XCTAssertNil(userAfterSignOut)
    }

    func testSignUpCreatesNewUser() async throws {
        let authService = MockAuthService()
        let user = try await authService.signUp(
            email: "new@example.com",
            password: "password",
            firstName: "Jane",
            lastName: "Doe"
        )
        XCTAssertEqual(user.firstName, "Jane")
        XCTAssertEqual(user.lastName, "Doe")
        XCTAssertEqual(user.email, "new@example.com")

        let currentUser = await authService.currentUser()
        XCTAssertNotNil(currentUser)
        XCTAssertEqual(currentUser?.firstName, "Jane")
    }

    func testUpdateProfile() async throws {
        let authService = MockAuthService()
        _ = try await authService.signIn(email: "test@example.com", password: "password")

        var updatedUser = MockUsers.currentUser
        updatedUser.firstName = "Updated"
        updatedUser.bio = "Updated bio"

        let result = try await authService.updateProfile(updatedUser)
        XCTAssertEqual(result.firstName, "Updated")
        XCTAssertEqual(result.bio, "Updated bio")
    }

    // MARK: - MockTaskService Tests

    func testFetchNearbyTasksReturnsNonEmpty() async throws {
        let taskService = MockTaskService()
        let tasks = try await taskService.fetchNearbyTasks(latitude: 39.78, longitude: -89.65, radiusMiles: 10)
        XCTAssertFalse(tasks.isEmpty)
        // All returned tasks should be open
        for task in tasks {
            XCTAssertEqual(task.status, .open)
        }
    }

    func testFetchTaskDetailReturnsCorrectTask() async throws {
        let taskService = MockTaskService()
        let task = try await taskService.fetchTaskDetail(id: "task-001")
        XCTAssertEqual(task.id, "task-001")
        XCTAssertEqual(task.title, "Open House at 123 Oak Street")
        XCTAssertEqual(task.category, .openHouse)
    }

    func testFetchTaskDetailThrowsForInvalidId() async throws {
        let taskService = MockTaskService()
        do {
            _ = try await taskService.fetchTaskDetail(id: "nonexistent-id")
            XCTFail("Expected NetworkingError.notFound to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkingError)
        }
    }

    func testCreateTask() async throws {
        let taskService = MockTaskService()
        let newTask = AgentTask(
            title: "Test Task",
            description: "A test task",
            category: .other,
            address: "999 Test St",
            city: "Testville",
            state: "IL",
            zipCode: "60000",
            latitude: 39.0,
            longitude: -89.0,
            compensation: 50.0,
            estimatedDuration: "1 hour",
            postedBy: MockUsers.currentUser
        )
        let created = try await taskService.createTask(newTask)
        XCTAssertEqual(created.title, "Test Task")

        let detail = try await taskService.fetchTaskDetail(id: created.id)
        XCTAssertEqual(detail.id, created.id)
    }

    func testApplyForTask() async throws {
        let taskService = MockTaskService()
        try await taskService.applyForTask(taskId: "task-001", message: "I'd like to help!")
        let task = try await taskService.fetchTaskDetail(id: "task-001")
        XCTAssertEqual(task.assignedTo?.id, MockUsers.currentUser.id)
        XCTAssertEqual(task.status, .assigned)
    }

    func testUpdateTaskStatus() async throws {
        let taskService = MockTaskService()
        try await taskService.updateTaskStatus(taskId: "task-003", status: .completed)
        let task = try await taskService.fetchTaskDetail(id: "task-003")
        XCTAssertEqual(task.status, .completed)
    }

    func testFetchMyPostedTasks() async throws {
        let taskService = MockTaskService()
        let tasks = try await taskService.fetchMyPostedTasks()
        XCTAssertFalse(tasks.isEmpty)
        for task in tasks {
            XCTAssertEqual(task.postedBy.id, MockUsers.currentUser.id)
        }
    }

    func testFetchMyAssignedTasks() async throws {
        let taskService = MockTaskService()
        let tasks = try await taskService.fetchMyAssignedTasks()
        XCTAssertFalse(tasks.isEmpty)
        for task in tasks {
            XCTAssertEqual(task.assignedTo?.id, MockUsers.currentUser.id)
        }
    }

    // MARK: - MockMessageService Tests

    func testFetchConversationsReturnsNonEmpty() async throws {
        let messageService = MockMessageService()
        let conversations = try await messageService.fetchConversations()
        XCTAssertFalse(conversations.isEmpty)
        XCTAssertEqual(conversations.count, 3)
    }

    func testFetchConversationsSortedByDate() async throws {
        let messageService = MockMessageService()
        let conversations = try await messageService.fetchConversations()
        for i in 0..<(conversations.count - 1) {
            XCTAssertGreaterThanOrEqual(conversations[i].lastMessageAt, conversations[i + 1].lastMessageAt)
        }
    }

    func testFetchMessages() async throws {
        let messageService = MockMessageService()
        let messages = try await messageService.fetchMessages(conversationId: "conv-001")
        XCTAssertFalse(messages.isEmpty)
        XCTAssertEqual(messages.count, 4)
        // Messages should be sorted by timestamp ascending
        for i in 0..<(messages.count - 1) {
            XCTAssertLessThanOrEqual(messages[i].timestamp, messages[i + 1].timestamp)
        }
    }

    func testSendMessage() async throws {
        let messageService = MockMessageService()
        let message = try await messageService.sendMessage(conversationId: "conv-001", text: "Hello there!")
        XCTAssertEqual(message.text, "Hello there!")
        XCTAssertEqual(message.conversationId, "conv-001")
        XCTAssertEqual(message.senderId, MockUsers.currentUser.id)

        let messages = try await messageService.fetchMessages(conversationId: "conv-001")
        XCTAssertEqual(messages.last?.text, "Hello there!")

        let conversations = try await messageService.fetchConversations()
        let conv = conversations.first { $0.id == "conv-001" }
        XCTAssertEqual(conv?.lastMessage, "Hello there!")
    }

    func testMarkAsRead() async throws {
        let messageService = MockMessageService()
        let conversationsBefore = try await messageService.fetchConversations()
        let convBefore = conversationsBefore.first { $0.id == "conv-001" }
        XCTAssertEqual(convBefore?.unreadCount, 2)

        try await messageService.markAsRead(conversationId: "conv-001")

        let conversationsAfter = try await messageService.fetchConversations()
        let convAfter = conversationsAfter.first { $0.id == "conv-001" }
        XCTAssertEqual(convAfter?.unreadCount, 0)
    }

    // MARK: - MockPaymentService Tests

    func testFetchEarnings() async throws {
        let paymentService = MockPaymentService()
        let earnings = try await paymentService.fetchEarnings()
        XCTAssertFalse(earnings.isEmpty)
    }

    func testFetchTotalEarnings() async throws {
        let paymentService = MockPaymentService()
        let total = try await paymentService.fetchTotalEarnings()
        XCTAssertGreaterThan(total, 0)
    }

    func testRequestPayout() async throws {
        let paymentService = MockPaymentService()
        // Should not throw
        try await paymentService.requestPayout(amount: 50.0)
    }

    // MARK: - MockProfileService Tests

    func testFetchProfile() async throws {
        let profileService = MockProfileService()
        let user = try await profileService.fetchProfile(userId: MockUsers.currentUser.id)
        XCTAssertEqual(user.id, MockUsers.currentUser.id)
        XCTAssertEqual(user.firstName, "Sarah")
    }

    func testFetchProfileThrowsForInvalidId() async throws {
        let profileService = MockProfileService()
        do {
            _ = try await profileService.fetchProfile(userId: "nonexistent")
            XCTFail("Expected NetworkingError.notFound to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkingError)
        }
    }

    func testFetchReviews() async throws {
        let profileService = MockProfileService()
        let reviews = try await profileService.fetchReviews(userId: MockUsers.currentUser.id)
        XCTAssertFalse(reviews.isEmpty)
        for review in reviews {
            XCTAssertEqual(review.revieweeId, MockUsers.currentUser.id)
        }
    }

    func testUpdateProfileInProfileService() async throws {
        let profileService = MockProfileService()
        var user = MockUsers.currentUser
        user.bio = "New bio from profile service"
        let updated = try await profileService.updateProfile(user)
        XCTAssertEqual(updated.bio, "New bio from profile service")

        let fetched = try await profileService.fetchProfile(userId: user.id)
        XCTAssertEqual(fetched.bio, "New bio from profile service")
    }

    // MARK: - MockNotificationService Tests

    func testFetchNotifications() async throws {
        let notificationService = MockNotificationService()
        let notifications = try await notificationService.fetchNotifications()
        XCTAssertFalse(notifications.isEmpty)
        // Should be sorted by date descending
        for i in 0..<(notifications.count - 1) {
            XCTAssertGreaterThanOrEqual(notifications[i].createdAt, notifications[i + 1].createdAt)
        }
    }

    func testUnreadCount() async throws {
        let notificationService = MockNotificationService()
        let count = try await notificationService.unreadCount()
        XCTAssertGreaterThan(count, 0)
    }

    func testMarkNotificationAsRead() async throws {
        let notificationService = MockNotificationService()
        let countBefore = try await notificationService.unreadCount()
        try await notificationService.markAsRead(notificationId: "notif-001")
        let countAfter = try await notificationService.unreadCount()
        XCTAssertEqual(countAfter, countBefore - 1)
    }
}
