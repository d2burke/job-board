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
        description: "Completed over 100 tasks on AgentAssist",
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

    private static let newcomerBadge = Badge(
        id: "badge-newcomer",
        name: "Rising Star",
        description: "Completed first 10 tasks with great reviews",
        iconName: "sparkles"
    )

    // MARK: - Date Helper

    private static func date(monthsAgo months: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: -months, to: Date()) ?? Date()
    }

    // MARK: - Users

    public static let currentUser = User(
        id: "user-001",
        firstName: "Alex",
        lastName: "Morgan",
        email: "alex.morgan@compass.com",
        phone: "(512) 555-0147",
        avatarURL: "https://randomuser.me/api/portraits/men/32.jpg",
        bio: "Licensed real estate agent specializing in residential properties across the Austin metro area. Passionate about helping clients find their dream homes and dedicated to providing exceptional service on every transaction.",
        licenseNumber: "TX-98234571",
        brokerage: "Compass Real Estate",
        specialties: [.openHouse, .showing, .photography, .staging],
        rating: 4.8,
        reviewCount: 87,
        completedTasks: 95,
        badges: [topRatedBadge, reliableBadge, quickResponderBadge],
        isVerified: true,
        joinDate: date(monthsAgo: 18)
    )

    public static let sarah = User(
        id: "user-002",
        firstName: "Sarah",
        lastName: "Chen",
        email: "sarah.chen@kw.com",
        phone: "(512) 555-0293",
        avatarURL: "https://randomuser.me/api/portraits/women/44.jpg",
        bio: "Top-producing agent with Keller Williams for over 8 years. I specialize in luxury listings and open houses across West Austin and Lakeway. Known for my attention to detail and strong negotiation skills.",
        licenseNumber: "TX-76543210",
        brokerage: "Keller Williams",
        specialties: [.openHouse, .staging, .photography, .showing],
        rating: 4.9,
        reviewCount: 143,
        completedTasks: 152,
        badges: [superAgentBadge, topRatedBadge, openHouseExpertBadge, reliableBadge],
        isVerified: true,
        joinDate: date(monthsAgo: 30)
    )

    public static let marcus = User(
        id: "user-003",
        firstName: "Marcus",
        lastName: "Johnson",
        email: "marcus.j@remax.com",
        phone: "(512) 555-0384",
        avatarURL: "https://randomuser.me/api/portraits/men/65.jpg",
        bio: "RE/MAX Premier agent focused on South Austin and Buda communities. I pride myself on being punctual, professional, and always going the extra mile for my clients. Expert in property showings and inspections.",
        licenseNumber: "TX-45678901",
        brokerage: "RE/MAX Premier",
        specialties: [.showing, .inspection, .signInstall, .lockbox],
        rating: 4.7,
        reviewCount: 76,
        completedTasks: 83,
        badges: [reliableBadge, quickResponderBadge],
        isVerified: false,
        joinDate: date(monthsAgo: 14)
    )

    public static let emily = User(
        id: "user-004",
        firstName: "Emily",
        lastName: "Rodriguez",
        email: "emily.r@compass.com",
        phone: "(512) 555-0471",
        avatarURL: "https://randomuser.me/api/portraits/women/68.jpg",
        bio: "Bilingual agent (English/Spanish) with Compass. My focus is East Austin and the rapidly growing Manor/Pflugerville corridor. I love staging and have an eye for transforming spaces that photograph beautifully.",
        licenseNumber: "TX-23456789",
        brokerage: "Compass",
        specialties: [.staging, .photography, .openHouse, .flyerDelivery],
        rating: 4.8,
        reviewCount: 110,
        completedTasks: 121,
        badges: [superAgentBadge, topRatedBadge, photographyProBadge],
        isVerified: true,
        joinDate: date(monthsAgo: 24)
    )

    public static let david = User(
        id: "user-005",
        firstName: "David",
        lastName: "Kim",
        email: "david.kim@coldwellbanker.com",
        phone: "(512) 555-0562",
        avatarURL: "https://randomuser.me/api/portraits/men/75.jpg",
        bio: "Coldwell Banker agent covering Round Rock and Cedar Park. Technology-driven approach to real estate with a background in architecture. I bring a unique perspective to property evaluations and inspections.",
        licenseNumber: "TX-34567890",
        brokerage: "Coldwell Banker",
        specialties: [.inspection, .photography, .research, .showing],
        rating: 4.6,
        reviewCount: 58,
        completedTasks: 67,
        badges: [reliableBadge, quickResponderBadge],
        isVerified: true,
        joinDate: date(monthsAgo: 12)
    )

    public static let jessica = User(
        id: "user-006",
        firstName: "Jessica",
        lastName: "Williams",
        email: "jessica.w@sothebys.com",
        phone: "(512) 555-0653",
        avatarURL: "https://randomuser.me/api/portraits/women/90.jpg",
        bio: "Sotheby's International Realty specialist in luxury and estate properties. With over 200 completed tasks, I bring unmatched professionalism to every assignment. My staging consultations have helped sellers net top dollar.",
        licenseNumber: "TX-56789012",
        brokerage: "Sotheby's International Realty",
        specialties: [.staging, .openHouse, .photography, .showing],
        rating: 4.9,
        reviewCount: 189,
        completedTasks: 201,
        badges: [superAgentBadge, topRatedBadge, openHouseExpertBadge, photographyProBadge, reliableBadge],
        isVerified: true,
        joinDate: date(monthsAgo: 36)
    )

    public static let ryan = User(
        id: "user-007",
        firstName: "Ryan",
        lastName: "O'Brien",
        email: "ryan.obrien@century21.com",
        phone: "(512) 555-0744",
        avatarURL: "https://randomuser.me/api/portraits/men/42.jpg",
        bio: "Century 21 agent newer to the Austin market but bringing 5 years of experience from the Dallas-Fort Worth area. Eager to take on tasks and build my local network. Specializing in sign installs and lockbox management.",
        licenseNumber: "TX-67890123",
        brokerage: "Century 21",
        specialties: [.signInstall, .lockbox, .flyerDelivery, .showing],
        rating: 4.5,
        reviewCount: 39,
        completedTasks: 45,
        badges: [newcomerBadge, quickResponderBadge],
        isVerified: false,
        joinDate: date(monthsAgo: 8)
    )

    public static let nina = User(
        id: "user-008",
        firstName: "Nina",
        lastName: "Patel",
        email: "nina.patel@exprealty.com",
        phone: "(512) 555-0835",
        avatarURL: "https://randomuser.me/api/portraits/women/55.jpg",
        bio: "eXp Realty agent with a strong presence in the tech corridor from Downtown to Domain. I combine market research expertise with hands-on task execution. My clients appreciate my data-driven approach to every assignment.",
        licenseNumber: "TX-78901234",
        brokerage: "eXp Realty",
        specialties: [.research, .inspection, .openHouse, .photography],
        rating: 4.7,
        reviewCount: 81,
        completedTasks: 88,
        badges: [reliableBadge, topRatedBadge],
        isVerified: true,
        joinDate: date(monthsAgo: 16)
    )

    public static let carlos = User(
        id: "user-009",
        firstName: "Carlos",
        lastName: "Mendez",
        email: "carlos.m@berkshire.com",
        phone: "(512) 555-0926",
        avatarURL: "https://randomuser.me/api/portraits/men/22.jpg",
        bio: "Berkshire Hathaway HomeServices agent and Austin native. I know every neighborhood in this city and bring that local expertise to every task. Fluent in English and Spanish, with a specialty in open houses and community outreach.",
        licenseNumber: "TX-89012345",
        brokerage: "Berkshire Hathaway HomeServices",
        specialties: [.openHouse, .showing, .flyerDelivery, .signInstall],
        rating: 4.8,
        reviewCount: 125,
        completedTasks: 134,
        badges: [superAgentBadge, topRatedBadge, openHouseExpertBadge, reliableBadge],
        isVerified: true,
        joinDate: date(monthsAgo: 22)
    )

    public static let lisa = User(
        id: "user-010",
        firstName: "Lisa",
        lastName: "Thompson",
        email: "lisa.t@remax.com",
        phone: "(512) 555-1017",
        avatarURL: "https://randomuser.me/api/portraits/women/33.jpg",
        bio: "RE/MAX agent just getting started on AgentAssist. Previously worked in property management for 3 years, so I bring strong organizational skills to every task. Eager to grow my reputation on the platform.",
        licenseNumber: "TX-90123456",
        brokerage: "RE/MAX",
        specialties: [.lockbox, .signInstall, .inspection, .flyerDelivery],
        rating: 4.4,
        reviewCount: 32,
        completedTasks: 38,
        badges: [newcomerBadge],
        isVerified: false,
        joinDate: date(monthsAgo: 5)
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
