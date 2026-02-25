import XCTest
@testable import SharedModels

final class SharedModelsTests: XCTestCase {

    // MARK: - User Tests

    func testUserFullName() {
        let user = User(
            firstName: "John",
            lastName: "Doe",
            email: "john@test.com",
            phone: "555-0000",
            bio: "Test bio"
        )
        XCTAssertEqual(user.fullName, "John Doe")
    }

    func testCurrentUserFullName() {
        XCTAssertEqual(MockUsers.currentUser.fullName, "Alex Morgan")
    }

    // MARK: - AgentTask Tests

    func testFormattedCompensation() {
        let task = AgentTask(
            title: "Test Task",
            description: "A test task",
            category: .openHouse,
            status: .open,
            address: "123 Main St",
            city: "Austin",
            state: "TX",
            zipCode: "78701",
            latitude: 30.2672,
            longitude: -97.7431,
            compensation: 150,
            estimatedDuration: "2 hours",
            postedBy: MockUsers.currentUser
        )
        XCTAssertEqual(task.formattedCompensation, "$150")
    }

    func testFormattedCompensationDecimal() {
        let task = AgentTask(
            title: "Test Task",
            description: "A test task",
            category: .showing,
            status: .open,
            address: "456 Oak Ave",
            city: "Austin",
            state: "TX",
            zipCode: "78702",
            latitude: 30.2600,
            longitude: -97.7300,
            compensation: 85.50,
            estimatedDuration: "1 hour",
            postedBy: MockUsers.currentUser
        )
        XCTAssertEqual(task.formattedCompensation, "$86")
    }

    func testFullAddress() {
        let task = AgentTask(
            title: "Test",
            description: "Test",
            category: .lockbox,
            status: .open,
            address: "789 E 6th St",
            city: "Austin",
            state: "TX",
            zipCode: "78702",
            latitude: 30.2656,
            longitude: -97.7253,
            compensation: 35,
            estimatedDuration: "30 min",
            postedBy: MockUsers.currentUser
        )
        XCTAssertEqual(task.fullAddress, "789 E 6th St, Austin, TX 78702")
    }

    // MARK: - TaskCategory Tests

    func testTaskCategoryAllCasesCount() {
        XCTAssertEqual(TaskCategory.allCases.count, 10)
    }

    func testTaskCategoryDisplayNames() {
        XCTAssertEqual(TaskCategory.openHouse.displayName, "Open House")
        XCTAssertEqual(TaskCategory.showing.displayName, "Showing")
        XCTAssertEqual(TaskCategory.photography.displayName, "Photography")
        XCTAssertEqual(TaskCategory.inspection.displayName, "Inspection")
        XCTAssertEqual(TaskCategory.staging.displayName, "Staging")
        XCTAssertEqual(TaskCategory.signInstall.displayName, "Sign Install")
        XCTAssertEqual(TaskCategory.lockbox.displayName, "Lockbox")
        XCTAssertEqual(TaskCategory.flyerDelivery.displayName, "Flyer Delivery")
        XCTAssertEqual(TaskCategory.research.displayName, "Research")
        XCTAssertEqual(TaskCategory.other.displayName, "Other")
    }

    func testTaskCategoryIconNames() {
        XCTAssertEqual(TaskCategory.openHouse.iconName, "door.left.hand.open")
        XCTAssertEqual(TaskCategory.showing.iconName, "key.fill")
        XCTAssertEqual(TaskCategory.photography.iconName, "camera.fill")
    }

    // MARK: - Mock Arrays Non-Empty Tests

    func testMockUsersNotEmpty() {
        XCTAssertFalse(MockUsers.allUsers.isEmpty)
        XCTAssertGreaterThanOrEqual(MockUsers.allUsers.count, 10)
    }

    func testMockTasksNotEmpty() {
        XCTAssertFalse(MockTasks.allTasks.isEmpty)
        XCTAssertGreaterThanOrEqual(MockTasks.allTasks.count, 15)
    }

    func testMockOpenTasksNotEmpty() {
        XCTAssertFalse(MockTasks.openTasks.isEmpty)
    }

    func testMockMyTasksNotEmpty() {
        XCTAssertFalse(MockTasks.myTasks.isEmpty)
    }

    func testMockConversationsNotEmpty() {
        XCTAssertFalse(MockMessages.allConversations.isEmpty)
        XCTAssertGreaterThanOrEqual(MockMessages.allConversations.count, 3)
    }

    func testMockReviewsNotEmpty() {
        XCTAssertFalse(MockReviews.allReviews.isEmpty)
        XCTAssertGreaterThanOrEqual(MockReviews.allReviews.count, 10)
    }

    func testMessagesForConversation() {
        let messages = MockMessages.messagesFor(conversationId: "conv-001")
        XCTAssertFalse(messages.isEmpty)
        XCTAssertGreaterThanOrEqual(messages.count, 5)
    }

    func testReviewsForUser() {
        let reviews = MockReviews.reviewsFor(userId: MockUsers.currentUser.id)
        XCTAssertFalse(reviews.isEmpty)
    }

    // MARK: - Codable Round-Trip Tests

    func testUserCodableRoundTrip() throws {
        let user = MockUsers.currentUser
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(user)
        let decoded = try decoder.decode(User.self, from: data)

        XCTAssertEqual(user.id, decoded.id)
        XCTAssertEqual(user.firstName, decoded.firstName)
        XCTAssertEqual(user.lastName, decoded.lastName)
        XCTAssertEqual(user.email, decoded.email)
        XCTAssertEqual(user.phone, decoded.phone)
        XCTAssertEqual(user.avatarURL, decoded.avatarURL)
        XCTAssertEqual(user.bio, decoded.bio)
        XCTAssertEqual(user.licenseNumber, decoded.licenseNumber)
        XCTAssertEqual(user.brokerage, decoded.brokerage)
        XCTAssertEqual(user.specialties, decoded.specialties)
        XCTAssertEqual(user.rating, decoded.rating)
        XCTAssertEqual(user.reviewCount, decoded.reviewCount)
        XCTAssertEqual(user.completedTasks, decoded.completedTasks)
        XCTAssertEqual(user.badges, decoded.badges)
        XCTAssertEqual(user.isVerified, decoded.isVerified)
        XCTAssertEqual(user.fullName, decoded.fullName)
    }

    func testAgentTaskCodableRoundTrip() throws {
        let task = MockTasks.openHouseElmCreek
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(task)
        let decoded = try decoder.decode(AgentTask.self, from: data)

        XCTAssertEqual(task.id, decoded.id)
        XCTAssertEqual(task.title, decoded.title)
        XCTAssertEqual(task.description, decoded.description)
        XCTAssertEqual(task.category, decoded.category)
        XCTAssertEqual(task.status, decoded.status)
        XCTAssertEqual(task.address, decoded.address)
        XCTAssertEqual(task.city, decoded.city)
        XCTAssertEqual(task.state, decoded.state)
        XCTAssertEqual(task.zipCode, decoded.zipCode)
        XCTAssertEqual(task.latitude, decoded.latitude)
        XCTAssertEqual(task.longitude, decoded.longitude)
        XCTAssertEqual(task.compensation, decoded.compensation)
        XCTAssertEqual(task.estimatedDuration, decoded.estimatedDuration)
        XCTAssertEqual(task.postedBy, decoded.postedBy)
        XCTAssertEqual(task.formattedCompensation, decoded.formattedCompensation)
        XCTAssertEqual(task.fullAddress, decoded.fullAddress)
    }

    func testMessageCodableRoundTrip() throws {
        let messages = MockMessages.messagesFor(conversationId: "conv-001")
        let message = messages[0]
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(message)
        let decoded = try decoder.decode(Message.self, from: data)

        XCTAssertEqual(message.id, decoded.id)
        XCTAssertEqual(message.conversationId, decoded.conversationId)
        XCTAssertEqual(message.senderId, decoded.senderId)
        XCTAssertEqual(message.text, decoded.text)
        XCTAssertEqual(message.isRead, decoded.isRead)
    }

    func testReviewCodableRoundTrip() throws {
        let review = MockReviews.allReviews[0]
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(review)
        let decoded = try decoder.decode(Review.self, from: data)

        XCTAssertEqual(review.id, decoded.id)
        XCTAssertEqual(review.taskId, decoded.taskId)
        XCTAssertEqual(review.reviewerId, decoded.reviewerId)
        XCTAssertEqual(review.revieweeId, decoded.revieweeId)
        XCTAssertEqual(review.rating, decoded.rating)
        XCTAssertEqual(review.comment, decoded.comment)
        XCTAssertEqual(review.reviewerName, decoded.reviewerName)
    }

    func testPaymentCodableRoundTrip() throws {
        let payment = Payment(
            taskId: "task-001",
            amount: 150.00,
            status: .completed,
            payerId: MockUsers.sarah.id,
            payeeId: MockUsers.currentUser.id,
            taskTitle: "Open House at 1204 Elm Creek"
        )
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(payment)
        let decoded = try decoder.decode(Payment.self, from: data)

        XCTAssertEqual(payment.taskId, decoded.taskId)
        XCTAssertEqual(payment.amount, decoded.amount)
        XCTAssertEqual(payment.status, decoded.status)
        XCTAssertEqual(payment.formattedAmount, decoded.formattedAmount)
        XCTAssertEqual(payment.formattedAmount, "$150.00")
    }
}
