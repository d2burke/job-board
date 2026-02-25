import Foundation

public struct Message: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public var conversationId: String
    public var senderId: String
    public var text: String
    public var timestamp: Date
    public var isRead: Bool

    public init(
        id: String = UUID().uuidString,
        conversationId: String,
        senderId: String,
        text: String,
        timestamp: Date = Date(),
        isRead: Bool = false
    ) {
        self.id = id
        self.conversationId = conversationId
        self.senderId = senderId
        self.text = text
        self.timestamp = timestamp
        self.isRead = isRead
    }
}
