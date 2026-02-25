import Testing
import Foundation
@testable import Messaging
import SharedModels
import Networking

// MARK: - Synchronous Mock Message Service

struct SyncMockMessageService: MessageServiceProtocol {
    var conversationsToReturn: [Conversation] = []
    var messagesToReturn: [Message] = []
    var sentMessages: [Message] = []

    func fetchConversations() async throws -> [Conversation] {
        return conversationsToReturn
    }

    func fetchMessages(conversationId: String) async throws -> [Message] {
        return messagesToReturn
    }

    func sendMessage(conversationId: String, text: String) async throws -> Message {
        return Message(
            conversationId: conversationId,
            senderId: "user-001",
            text: text,
            timestamp: Date(),
            isRead: true
        )
    }

    func markAsRead(conversationId: String) async throws {
        // No-op for tests
    }
}

// MARK: - Tests

@Suite("ChatViewModel Tests")
struct ChatViewModelTests {

    // MARK: - Helpers

    private static var sampleConversation: Conversation {
        Conversation(
            id: "conv-test-001",
            participants: [
                User(
                    id: "user-001",
                    firstName: "Alex",
                    lastName: "Morgan",
                    email: "alex@test.com",
                    phone: "(555) 000-0001",
                    bio: "Test user"
                ),
                User(
                    id: "user-002",
                    firstName: "Sarah",
                    lastName: "Chen",
                    email: "sarah@test.com",
                    phone: "(555) 000-0002",
                    bio: "Test user 2"
                )
            ],
            lastMessage: "Hello there!",
            lastMessageAt: Date(),
            unreadCount: 1,
            taskTitle: "Test Task"
        )
    }

    private static var sampleCurrentUser: User {
        User(
            id: "user-001",
            firstName: "Alex",
            lastName: "Morgan",
            email: "alex@test.com",
            phone: "(555) 000-0001",
            bio: "Test user"
        )
    }

    private static var sampleMessages: [Message] {
        [
            Message(
                id: "msg-001",
                conversationId: "conv-test-001",
                senderId: "user-002",
                text: "Hi Alex, are you available this weekend?",
                timestamp: Calendar.current.date(byAdding: .hour, value: -3, to: Date())!,
                isRead: true
            ),
            Message(
                id: "msg-002",
                conversationId: "conv-test-001",
                senderId: "user-001",
                text: "Yes! Saturday works for me.",
                timestamp: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!,
                isRead: true
            ),
            Message(
                id: "msg-003",
                conversationId: "conv-test-001",
                senderId: "user-002",
                text: "Great, let's plan for 10 AM.",
                timestamp: Calendar.current.date(byAdding: .hour, value: -1, to: Date())!,
                isRead: false
            )
        ]
    }

    // MARK: - Load Messages Tests

    @Test("loadMessages populates messages array")
    @MainActor
    func loadMessages() async {
        let service = SyncMockMessageService(
            messagesToReturn: ChatViewModelTests.sampleMessages
        )
        let vm = ChatViewModel(
            messageService: service,
            conversation: ChatViewModelTests.sampleConversation,
            currentUser: ChatViewModelTests.sampleCurrentUser
        )

        #expect(vm.messages.isEmpty)

        vm.loadMessages()

        // Allow async task to complete
        try? await Task.sleep(for: .milliseconds(100))

        #expect(vm.messages.count == 3)
        #expect(vm.messages.first?.text == "Hi Alex, are you available this weekend?")
        #expect(vm.messages.last?.text == "Great, let's plan for 10 AM.")
    }

    // MARK: - Send Message Tests

    @Test("sendMessage appends message and clears text field")
    @MainActor
    func sendMessage() async {
        let service = SyncMockMessageService(
            messagesToReturn: ChatViewModelTests.sampleMessages
        )
        let vm = ChatViewModel(
            messageService: service,
            conversation: ChatViewModelTests.sampleConversation,
            currentUser: ChatViewModelTests.sampleCurrentUser
        )

        // Pre-load messages
        vm.loadMessages()
        try? await Task.sleep(for: .milliseconds(100))

        let initialCount = vm.messages.count
        vm.messageText = "Sounds perfect!"
        vm.sendMessage()

        // Allow async task to complete
        try? await Task.sleep(for: .milliseconds(100))

        #expect(vm.messages.count == initialCount + 1)
        #expect(vm.messages.last?.text == "Sounds perfect!")
        #expect(vm.messageText.isEmpty)
    }

    @Test("sendMessage does nothing with empty text")
    @MainActor
    func sendEmptyMessage() async {
        let service = SyncMockMessageService()
        let vm = ChatViewModel(
            messageService: service,
            conversation: ChatViewModelTests.sampleConversation,
            currentUser: ChatViewModelTests.sampleCurrentUser
        )

        vm.messageText = "   "
        vm.sendMessage()

        try? await Task.sleep(for: .milliseconds(100))

        #expect(vm.messages.isEmpty)
    }

    @Test("sendMessage does nothing with whitespace-only text")
    @MainActor
    func sendWhitespaceMessage() async {
        let service = SyncMockMessageService()
        let vm = ChatViewModel(
            messageService: service,
            conversation: ChatViewModelTests.sampleConversation,
            currentUser: ChatViewModelTests.sampleCurrentUser
        )

        vm.messageText = "\n  \t  "
        vm.sendMessage()

        try? await Task.sleep(for: .milliseconds(100))

        #expect(vm.messages.isEmpty)
    }

    // MARK: - Initial State Tests

    @Test("Initial state is correct")
    func initialState() {
        let service = SyncMockMessageService()
        let vm = ChatViewModel(
            messageService: service,
            conversation: ChatViewModelTests.sampleConversation,
            currentUser: ChatViewModelTests.sampleCurrentUser
        )

        #expect(vm.messages.isEmpty)
        #expect(vm.messageText.isEmpty)
        #expect(vm.isLoading == false)
        #expect(vm.currentUserId == "user-001")
        #expect(vm.conversation.id == "conv-test-001")
    }
}
