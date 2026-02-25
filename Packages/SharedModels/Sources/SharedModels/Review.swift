import Foundation

public struct Review: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public var taskId: String
    public var reviewerId: String
    public var revieweeId: String
    public var rating: Double
    public var comment: String
    public var createdAt: Date
    public var reviewerName: String
    public var reviewerAvatarURL: String?

    public init(
        id: String = UUID().uuidString,
        taskId: String,
        reviewerId: String,
        revieweeId: String,
        rating: Double,
        comment: String,
        createdAt: Date = Date(),
        reviewerName: String,
        reviewerAvatarURL: String? = nil
    ) {
        self.id = id
        self.taskId = taskId
        self.reviewerId = reviewerId
        self.revieweeId = revieweeId
        self.rating = rating
        self.comment = comment
        self.createdAt = createdAt
        self.reviewerName = reviewerName
        self.reviewerAvatarURL = reviewerAvatarURL
    }
}
