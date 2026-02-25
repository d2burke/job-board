import Foundation

public struct Badge: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public var name: String
    public var description: String
    public var iconName: String

    public init(
        id: String = UUID().uuidString,
        name: String,
        description: String,
        iconName: String
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.iconName = iconName
    }
}
