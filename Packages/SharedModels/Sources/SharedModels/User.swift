import Foundation

public struct User: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public var firstName: String
    public var lastName: String
    public var email: String
    public var phone: String
    public var avatarURL: String?
    public var bio: String
    public var licenseNumber: String?
    public var brokerage: String?
    public var specialties: [TaskCategory]
    public var rating: Double
    public var reviewCount: Int
    public var completedTasks: Int
    public var badges: [Badge]
    public var isVerified: Bool
    public var joinDate: Date

    public var fullName: String { "\(firstName) \(lastName)" }

    public init(
        id: String = UUID().uuidString,
        firstName: String,
        lastName: String,
        email: String,
        phone: String,
        avatarURL: String? = nil,
        bio: String,
        licenseNumber: String? = nil,
        brokerage: String? = nil,
        specialties: [TaskCategory] = [],
        rating: Double = 0.0,
        reviewCount: Int = 0,
        completedTasks: Int = 0,
        badges: [Badge] = [],
        isVerified: Bool = false,
        joinDate: Date = Date()
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.avatarURL = avatarURL
        self.bio = bio
        self.licenseNumber = licenseNumber
        self.brokerage = brokerage
        self.specialties = specialties
        self.rating = rating
        self.reviewCount = reviewCount
        self.completedTasks = completedTasks
        self.badges = badges
        self.isVerified = isVerified
        self.joinDate = joinDate
    }
}
