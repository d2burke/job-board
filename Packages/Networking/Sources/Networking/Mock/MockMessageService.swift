import Foundation
import SharedModels

@MainActor
public final class MockMessageService: MessageServiceProtocol {
    private var conversations: [Conversation]
    private var messages: [String: [Message]]

    public init() {
        self.conversations = MockMessages.allConversations
        self.messages = MockMessages.allMessages
    }

    nonisolated public func fetchConversations() async throws -> [Conversation] {
        try await Task.sleep(for: .milliseconds(300))
        let allConversations = await MainActor.run { self.conversations }
        return allConversations.sorted { $0.lastMessageAt > $1.lastMessageAt }
    }

    nonisolated public func fetchMessages(conversationId: String) async throws -> [Message] {
        try await Task.sleep(for: .milliseconds(300))
        let allMessages = await MainActor.run { self.messages }
        let conversationMessages = allMessages[conversationId] ?? []
        return conversationMessages.sorted { $0.timestamp < $1.timestamp }
    }

    nonisolated public func sendMessage(conversationId: String, text: String) async throws -> Message {
        try await Task.sleep(for: .milliseconds(300))
        let newMessage = Message(
            conversationId: conversationId,
            senderId: MockUsers.currentUser.id,
            text: text,
            timestamp: Date(),
            isRead: true
        )
        await MainActor.run {
            if self.messages[conversationId] != nil {
                self.messages[conversationId]!.append(newMessage)
            } else {
                self.messages[conversationId] = [newMessage]
            }
            if let index = self.conversations.firstIndex(where: { $0.id == conversationId }) {
                self.conversations[index].lastMessage = text
                self.conversations[index].lastMessageAt = Date()
            }
        }
        return newMessage
    }

    nonisolated public func markAsRead(conversationId: String) async throws {
        try await Task.sleep(for: .milliseconds(300))
        await MainActor.run {
            if let index = self.conversations.firstIndex(where: { $0.id == conversationId }) {
                self.conversations[index].unreadCount = 0
            }
            if var conversationMessages = self.messages[conversationId] {
                for i in conversationMessages.indices {
                    conversationMessages[i].isRead = true
                }
                self.messages[conversationId] = conversationMessages
            }
        }
    }
}
