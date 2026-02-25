import Foundation

public struct Conversation: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public var participants: [User]
    public var lastMessage: String
    public var lastMessageAt: Date
    public var unreadCount: Int
    public var taskTitle: String?

    public init(
        id: String = UUID().uuidString,
        participants: [User],
        lastMessage: String,
        lastMessageAt: Date = Date(),
        unreadCount: Int = 0,
        taskTitle: String? = nil
    ) {
        self.id = id
        self.participants = participants
        self.lastMessage = lastMessage
        self.lastMessageAt = lastMessageAt
        self.unreadCount = unreadCount
        self.taskTitle = taskTitle
    }
}
