import Foundation

public enum TaskCategory: String, Codable, Hashable, Sendable, CaseIterable, Identifiable {
    case openHouse
    case showing
    case photography
    case inspection
    case staging
    case signInstall
    case lockbox
    case flyerDelivery
    case research
    case other

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .openHouse: return "Open House"
        case .showing: return "Showing"
        case .photography: return "Photography"
        case .inspection: return "Inspection"
        case .staging: return "Staging"
        case .signInstall: return "Sign Install"
        case .lockbox: return "Lockbox"
        case .flyerDelivery: return "Flyer Delivery"
        case .research: return "Research"
        case .other: return "Other"
        }
    }

    public var iconName: String {
        switch self {
        case .openHouse: return "door.left.hand.open"
        case .showing: return "key.fill"
        case .photography: return "camera.fill"
        case .inspection: return "magnifyingglass"
        case .staging: return "sofa.fill"
        case .signInstall: return "signpost.right.fill"
        case .lockbox: return "lock.fill"
        case .flyerDelivery: return "envelope.fill"
        case .research: return "doc.text.magnifyingglass"
        case .other: return "ellipsis.circle.fill"
        }
    }
}
