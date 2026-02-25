import Foundation

public enum PaymentStatus: String, Codable, Hashable, Sendable, CaseIterable, Identifiable {
    case pending
    case completed
    case failed
    case refunded

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .pending: return "Pending"
        case .completed: return "Completed"
        case .failed: return "Failed"
        case .refunded: return "Refunded"
        }
    }
}

public struct Payment: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public var taskId: String
    public var amount: Double
    public var status: PaymentStatus
    public var payerId: String
    public var payeeId: String
    public var createdAt: Date
    public var taskTitle: String

    public var formattedAmount: String { String(format: "$%.2f", amount) }

    public init(
        id: String = UUID().uuidString,
        taskId: String,
        amount: Double,
        status: PaymentStatus = .pending,
        payerId: String,
        payeeId: String,
        createdAt: Date = Date(),
        taskTitle: String
    ) {
        self.id = id
        self.taskId = taskId
        self.amount = amount
        self.status = status
        self.payerId = payerId
        self.payeeId = payeeId
        self.createdAt = createdAt
        self.taskTitle = taskTitle
    }
}
