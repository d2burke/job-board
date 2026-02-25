import Foundation

public enum NotificationType: String, Codable, Hashable, Sendable, CaseIterable, Identifiable {
    case taskAssigned
    case taskCompleted
    case newMessage
    case paymentReceived
    case reviewReceived
    case taskCancelled

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .taskAssigned: return "Task Assigned"
        case .taskCompleted: return "Task Completed"
        case .newMessage: return "New Message"
        case .paymentReceived: return "Payment Received"
        case .reviewReceived: return "Review Received"
        case .taskCancelled: return "Task Cancelled"
        }
    }
}

public struct AppNotification: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public var type: NotificationType
    public var title: String
    public var body: String
    public var isRead: Bool
    public var createdAt: Date
    public var relatedTaskId: String?

    public init(
        id: String = UUID().uuidString,
        type: NotificationType,
        title: String,
        body: String,
        isRead: Bool = false,
        createdAt: Date = Date(),
        relatedTaskId: String? = nil
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.body = body
        self.isRead = isRead
        self.createdAt = createdAt
        self.relatedTaskId = relatedTaskId
    }
}
