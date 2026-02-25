import Foundation

public enum TaskStatus: String, Codable, Hashable, Sendable, CaseIterable, Identifiable {
    case open
    case assigned
    case inProgress
    case completed
    case cancelled

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .open: return "Open"
        case .assigned: return "Assigned"
        case .inProgress: return "In Progress"
        case .completed: return "Completed"
        case .cancelled: return "Cancelled"
        }
    }
}
