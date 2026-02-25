import Foundation

public struct AgentTask: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public var title: String
    public var description: String
    public var category: TaskCategory
    public var status: TaskStatus
    public var address: String
    public var city: String
    public var state: String
    public var zipCode: String
    public var latitude: Double
    public var longitude: Double
    public var compensation: Double
    public var estimatedDuration: String
    public var postedBy: User
    public var assignedTo: User?
    public var createdAt: Date
    public var scheduledFor: Date?
    public var photos: [String]
    public var requirements: [String]

    public var formattedCompensation: String { String(format: "$%.0f", compensation) }
    public var fullAddress: String { "\(address), \(city), \(state) \(zipCode)" }

    public init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        category: TaskCategory,
        status: TaskStatus = .open,
        address: String,
        city: String,
        state: String,
        zipCode: String,
        latitude: Double,
        longitude: Double,
        compensation: Double,
        estimatedDuration: String,
        postedBy: User,
        assignedTo: User? = nil,
        createdAt: Date = Date(),
        scheduledFor: Date? = nil,
        photos: [String] = [],
        requirements: [String] = []
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.status = status
        self.address = address
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.latitude = latitude
        self.longitude = longitude
        self.compensation = compensation
        self.estimatedDuration = estimatedDuration
        self.postedBy = postedBy
        self.assignedTo = assignedTo
        self.createdAt = createdAt
        self.scheduledFor = scheduledFor
        self.photos = photos
        self.requirements = requirements
    }
}
