import SharedModels

public protocol MessageServiceProtocol: Sendable {
    func fetchConversations() async throws -> [Conversation]
    func fetchMessages(conversationId: String) async throws -> [Message]
    func sendMessage(conversationId: String, text: String) async throws -> Message
    func markAsRead(conversationId: String) async throws
}
