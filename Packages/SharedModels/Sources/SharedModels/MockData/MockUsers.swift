import Foundation

public enum MockUsers {
    // MARK: - Badges

    private static let topRatedBadge = Badge(
        id: "badge-top-rated",
        name: "Top Rated",
        description: "Maintained a 4.8+ rating over 50 tasks",
        iconName: "star.fill"
    )

    private static let superAgentBadge = Badge(
        id: "badge-super-agent",
        name: "Super Agent",
        description: "Completed over 100 tasks",
        iconName: "bolt.fill"
    )

    private static let quickResponderBadge = Badge(
        id: "badge-quick-responder",
        name: "Quick Responder",
        description: "Average response time under 15 minutes",
        iconName: "clock.fill"
    )

    private static let photographyProBadge = Badge(
        id: "badge-photo-pro",
        name: "Photography Pro",
        description: "Completed 25+ photography tasks with 5-star ratings",
        iconName: "camera.fill"
    )

    private static let openHouseExpertBadge = Badge(
        id: "badge-open-house-expert",
        name: "Open House Expert",
        description: "Hosted 50+ open houses",
        iconName: "door.left.hand.open"
    )

    private static let reliableBadge = Badge(
        id: "badge-reliable",
        name: "Reliable",
        description: "Zero cancellations in the last 6 months",
        iconName: "checkmark.seal.fill"
    )

    private static let newMemberBadge = Badge(
        id: "badge-new-member",
        name: "New Member",
        description: "Welcome to AgentAssist!",
        iconName: "hand.wave.fill"
    )

    // MARK: - Users

    public static let currentUser = User(
        id: "user-001",
        firstName: "Alex",
        lastName: "Morgan",
        email: "alex.morgan@compass.com",
        phone: "(512) 555-0101",
        avatarURL: "https://randomuser.me/api/portraits/men/32.jpg",
        bio: "Licensed Texas real estate agent with 8 years of experience in the Austin metro area. Specializing in residential properties and open houses. Passionate about helping clients find their dream homes.",
        licenseNumber: "TX-98765432",
        brokerage: "Compass Real Estate",
        specialties: [.openHouse, .showing, .photography, .staging],
        rating: 4.8,
        reviewCount: 87,
        completedTasks: 95,
        badges: [topRatedBadge, superAgentBadge, quickResponderBadge, reliableBadge],
        isVerified: true,
        joinDate: Calendar.current.date(from: DateComponents(year: 2023, month: 3, day: 15))!
    )

    public static let sarah = User(
        id: "user-002",
        firstName: "Sarah",
        lastName: "Chen",
        email: "sarah.chen@kw.com",
        phone: "(512) 555-0202",
        avatarURL: "https://randomuser.me/api/portraits/women/44.jpg",
        bio: "Top-producing agent at Keller Williams with a focus on luxury properties in the Austin Hills area. Known for meticulous staging and exceptional client communication.",
        licenseNumber: "TX-11223344",
        brokerage: "Keller Williams",
        specialties: [.staging, .openHouse, .photography, .showing],
        rating: 4.9,
        reviewCount: 143,
        completedTasks: 152,
        badges: [topRatedBadge, superAgentBadge, openHouseExpertBadge, reliableBadge],
        isVerified: true,
        joinDate: Calendar.current.date(from: DateComponents(year: 2022, month: 8, day: 1))!
    )

    public static let marcus = User(
        id: "user-003",
        firstName: "Marcus",
        lastName: "Johnson",
        email: "marcus.j@remax.com",
        phone: "(512) 555-0303",
        avatarURL: "https://randomuser.me/api/portraits/men/65.jpg",
        bio: "Former contractor turned real estate agent. My construction background gives me a unique edge when it comes to property inspections and home evaluations.",
        licenseNumber: "TX-55667788",
        brokerage: "RE/MAX Premier",
        specialties: [.inspection, .signInstall, .lockbox, .research],
        rating: 4.7,
        reviewCount: 76,
        completedTasks: 83,
        badges: [quickResponderBadge, reliableBadge],
        isVerified: false,
        joinDate: Calendar.current.date(from: DateComponents(year: 2023, month: 1, day: 20))!
    )

    public static let emily = User(
        id: "user-004",
        firstName: "Emily",
        lastName: "Rodriguez",
        email: "emily.rod@compass.com",
        phone: "(512) 555-0404",
        avatarURL: "https://randomuser.me/api/portraits/women/28.jpg",
        bio: "Bilingual agent fluent in English and Spanish. I specialize in helping first-time homebuyers navigate the Austin market. Photography enthusiast with a professional setup for listings.",
        licenseNumber: "TX-33445566",
        brokerage: "Compass",
        specialties: [.photography, .showing, .flyerDelivery, .openHouse],
        rating: 4.8,
        reviewCount: 112,
        completedTasks: 121,
        badges: [topRatedBadge, superAgentBadge, photographyProBadge],
        isVerified: false,
        joinDate: Calendar.current.date(from: DateComponents(year: 2022, month: 11, day: 10))!
    )

    public static let david = User(
        id: "user-005",
        firstName: "David",
        lastName: "Kim",
        email: "david.kim@coldwellbanker.com",
        phone: "(512) 555-0505",
        avatarURL: "https://randomuser.me/api/portraits/men/52.jpg",
        bio: "Tech-savvy agent with deep knowledge of the East Austin market. I leverage data analytics to help clients make informed decisions. Certified drone photographer for aerial property shots.",
        licenseNumber: "TX-77889900",
        brokerage: "Coldwell Banker",
        specialties: [.photography, .research, .inspection, .openHouse],
        rating: 4.6,
        reviewCount: 59,
        completedTasks: 67,
        badges: [photographyProBadge, quickResponderBadge, reliableBadge],
        isVerified: true,
        joinDate: Calendar.current.date(from: DateComponents(year: 2023, month: 5, day: 8))!
    )

    public static let jessica = User(
        id: "user-006",
        firstName: "Jessica",
        lastName: "Williams",
        email: "jessica.w@sothebys.com",
        phone: "(512) 555-0606",
        avatarURL: "https://randomuser.me/api/portraits/women/63.jpg",
        bio: "Luxury property specialist with Sotheby's International Realty. Over 12 years in Austin real estate. Certified Home Staging Professional and relocation expert.",
        licenseNumber: "TX-12345678",
        brokerage: "Sotheby's International Realty",
        specialties: [.staging, .openHouse, .showing, .photography],
        rating: 4.9,
        reviewCount: 189,
        completedTasks: 201,
        badges: [topRatedBadge, superAgentBadge, openHouseExpertBadge, reliableBadge, quickResponderBadge],
        isVerified: true,
        joinDate: Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 14))!
    )

    public static let ryan = User(
        id: "user-007",
        firstName: "Ryan",
        lastName: "O'Brien",
        email: "ryan.obrien@century21.com",
        phone: "(512) 555-0707",
        avatarURL: "https://randomuser.me/api/portraits/men/22.jpg",
        bio: "Newer agent with a strong work ethic and eagerness to learn. Focused on South Austin neighborhoods. Available for sign installs, lockbox changes, and flyer deliveries on short notice.",
        licenseNumber: "TX-44556677",
        brokerage: "Century 21",
        specialties: [.signInstall, .lockbox, .flyerDelivery, .showing],
        rating: 4.5,
        reviewCount: 38,
        completedTasks: 45,
        badges: [quickResponderBadge, newMemberBadge],
        isVerified: false,
        joinDate: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 5))!
    )

    public static let nina = User(
        id: "user-008",
        firstName: "Nina",
        lastName: "Patel",
        email: "nina.patel@exprealty.com",
        phone: "(512) 555-0808",
        avatarURL: "https://randomuser.me/api/portraits/women/35.jpg",
        bio: "Detail-oriented agent specializing in market research and property analysis. MBA background brings a strategic approach to real estate. Expert in comparative market analysis and investment properties.",
        licenseNumber: "TX-66778899",
        brokerage: "eXp Realty",
        specialties: [.research, .inspection, .openHouse, .staging],
        rating: 4.7,
        reviewCount: 81,
        completedTasks: 88,
        badges: [topRatedBadge, reliableBadge],
        isVerified: false,
        joinDate: Calendar.current.date(from: DateComponents(year: 2023, month: 6, day: 22))!
    )

    public static let carlos = User(
        id: "user-009",
        firstName: "Carlos",
        lastName: "Mendez",
        email: "carlos.mendez@bhhstx.com",
        phone: "(512) 555-0909",
        avatarURL: "https://randomuser.me/api/portraits/men/45.jpg",
        bio: "Veteran Austin agent with deep roots in the community. Fluent in English and Spanish. Known for hosting exceptional open houses that consistently draw large crowds and generate strong offers.",
        licenseNumber: "TX-22334455",
        brokerage: "Berkshire Hathaway HomeServices",
        specialties: [.openHouse, .showing, .staging, .flyerDelivery],
        rating: 4.8,
        reviewCount: 126,
        completedTasks: 134,
        badges: [topRatedBadge, superAgentBadge, openHouseExpertBadge, quickResponderBadge],
        isVerified: true,
        joinDate: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 30))!
    )

    public static let lisa = User(
        id: "user-010",
        firstName: "Lisa",
        lastName: "Thompson",
        email: "lisa.thompson@remax.com",
        phone: "(512) 555-1010",
        avatarURL: "https://randomuser.me/api/portraits/women/50.jpg",
        bio: "Part-time agent and full-time mom getting back into the real estate world. Enthusiastic about helping with showings and open houses in the Cedar Park and Round Rock areas.",
        licenseNumber: "TX-99001122",
        brokerage: "RE/MAX",
        specialties: [.showing, .openHouse, .flyerDelivery, .lockbox],
        rating: 4.4,
        reviewCount: 32,
        completedTasks: 38,
        badges: [newMemberBadge, reliableBadge],
        isVerified: false,
        joinDate: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 12))!
    )

    // MARK: - All Users

    public static let allUsers: [User] = [
        currentUser,
        sarah,
        marcus,
        emily,
        david,
        jessica,
        ryan,
        nina,
        carlos,
        lisa
    ]
}
