import Foundation

public enum MockTasks {
    // MARK: - Date Helpers

    private static func date(daysFromNow days: Int, hour: Int = 10, minute: Int = 0) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = hour
        components.minute = minute
        let base = Calendar.current.date(from: components)!
        return Calendar.current.date(byAdding: .day, value: days, to: base)!
    }

    private static func pastDate(daysAgo days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -days, to: Date())!
    }

    // MARK: - Tasks

    public static let openHouseElmCreek = AgentTask(
        id: "task-001",
        title: "Open House at 1204 Elm Creek",
        description: "Host an open house for a beautifully renovated 3BR/2BA ranch-style home. Sign-in sheets, flyers, and refreshments will be provided. Please arrive 30 minutes early to set up. The home features a newly remodeled kitchen, hardwood floors throughout, and a spacious backyard.",
        category: .openHouse,
        status: .open,
        address: "1204 Elm Creek Dr",
        city: "Austin",
        state: "TX",
        zipCode: "78703",
        latitude: 30.2849,
        longitude: -97.7714,
        compensation: 150,
        estimatedDuration: "3 hours",
        postedBy: MockUsers.sarah,
        createdAt: pastDate(daysAgo: 1),
        scheduledFor: date(daysFromNow: 3, hour: 13),
        requirements: ["Professional attire required", "Must have tablet for sign-ins", "Arrive 30 min early"]
    )

    public static let photographyBartonSprings = AgentTask(
        id: "task-002",
        title: "Photography for 892 Barton Springs",
        description: "Professional interior and exterior photography needed for a luxury 4BR/3BA listing near Barton Springs. Must have DSLR camera and wide-angle lens. HDR shots preferred. Deliver edited photos within 48 hours.",
        category: .photography,
        status: .open,
        address: "892 Barton Springs Rd",
        city: "Austin",
        state: "TX",
        zipCode: "78704",
        latitude: 30.2598,
        longitude: -97.7557,
        compensation: 120,
        estimatedDuration: "2 hours",
        postedBy: MockUsers.jessica,
        createdAt: pastDate(daysAgo: 2),
        scheduledFor: date(daysFromNow: 2, hour: 10),
        requirements: ["DSLR camera required", "Wide-angle lens", "HDR capability", "48-hour delivery"]
    )

    public static let showingLakeAustin = AgentTask(
        id: "task-003",
        title: "Weekend Showing at 456 Lake Austin",
        description: "Conduct a private showing for a pre-qualified buyer couple interested in this waterfront property. 5BR/4BA with boat dock. Buyer is relocating from Dallas and has specific questions about the HOA and flood zones.",
        category: .showing,
        status: .open,
        address: "456 Lake Austin Blvd",
        city: "Austin",
        state: "TX",
        zipCode: "78703",
        latitude: 30.2936,
        longitude: -97.7853,
        compensation: 85,
        estimatedDuration: "1.5 hours",
        postedBy: MockUsers.carlos,
        createdAt: pastDate(daysAgo: 1),
        scheduledFor: date(daysFromNow: 5, hour: 14),
        requirements: ["Familiarity with Lake Austin area", "Knowledge of flood zone regulations"]
    )

    public static let signInstallSCongress = AgentTask(
        id: "task-004",
        title: "Sign Install at 2301 S Congress",
        description: "Install a For Sale yard sign and directional signs at the corners of S Congress and Oltorf. Post is already in the car and ready to go. Bring a mallet. Take photos of installed signs and send confirmation.",
        category: .signInstall,
        status: .assigned,
        address: "2301 S Congress Ave",
        city: "Austin",
        state: "TX",
        zipCode: "78704",
        latitude: 30.2442,
        longitude: -97.7490,
        compensation: 40,
        estimatedDuration: "30 minutes",
        postedBy: MockUsers.emily,
        assignedTo: MockUsers.ryan,
        createdAt: pastDate(daysAgo: 3),
        scheduledFor: date(daysFromNow: 1, hour: 9),
        requirements: ["Must have mallet", "Photo confirmation required"]
    )

    public static let stagingConsultation = AgentTask(
        id: "task-005",
        title: "Home Staging Consultation",
        description: "Provide a full staging consultation for a 2,400 sq ft home preparing to list. Create a room-by-room recommendation report including furniture arrangement, decor suggestions, and paint color recommendations. Homeowner has a $3,000 staging budget.",
        category: .staging,
        status: .open,
        address: "3567 Tarrytown Rd",
        city: "Austin",
        state: "TX",
        zipCode: "78703",
        latitude: 30.3012,
        longitude: -97.7731,
        compensation: 175,
        estimatedDuration: "4 hours",
        postedBy: MockUsers.jessica,
        createdAt: pastDate(daysAgo: 1),
        scheduledFor: date(daysFromNow: 4, hour: 11),
        requirements: ["Staging certification preferred", "Written report required", "Must provide before/after visualization"]
    )

    public static let lockboxReplacement = AgentTask(
        id: "task-006",
        title: "Lockbox Replacement at 789 E 6th",
        description: "Replace the existing combination lockbox with a new Supra eKEY lockbox. The old lockbox code is 4521. Please confirm the new lockbox is functional and report the access code.",
        category: .lockbox,
        status: .open,
        address: "789 E 6th St",
        city: "Austin",
        state: "TX",
        zipCode: "78702",
        latitude: 30.2656,
        longitude: -97.7253,
        compensation: 35,
        estimatedDuration: "30 minutes",
        postedBy: MockUsers.marcus,
        createdAt: pastDate(daysAgo: 4),
        requirements: ["Supra eKEY access required", "Confirm lockbox functionality"]
    )

    public static let inspectionPrep = AgentTask(
        id: "task-007",
        title: "Pre-Inspection Property Check",
        description: "Walk through the property before the official home inspection scheduled for next week. Check for obvious issues: leaky faucets, HVAC operation, garage door function, and any visible damage. Provide a written summary.",
        category: .inspection,
        status: .inProgress,
        address: "1100 S Lamar Blvd",
        city: "Austin",
        state: "TX",
        zipCode: "78704",
        latitude: 30.2521,
        longitude: -97.7631,
        compensation: 95,
        estimatedDuration: "2 hours",
        postedBy: MockUsers.nina,
        assignedTo: MockUsers.currentUser,
        createdAt: pastDate(daysAgo: 5),
        scheduledFor: date(daysFromNow: 0, hour: 14),
        requirements: ["Detailed written report", "Photos of any issues found", "Check all major systems"]
    )

    public static let flyerDeliveryDowntown = AgentTask(
        id: "task-008",
        title: "Flyer Delivery - Downtown Condos",
        description: "Deliver 200 listing flyers to the front desks and common areas of 5 downtown condo buildings: The Austonian, 360 Condos, Spring Condos, Seaholm Residences, and The Independent. Obtain permission from front desk before leaving flyers.",
        category: .flyerDelivery,
        status: .open,
        address: "200 Congress Ave",
        city: "Austin",
        state: "TX",
        zipCode: "78701",
        latitude: 30.2650,
        longitude: -97.7445,
        compensation: 60,
        estimatedDuration: "2 hours",
        postedBy: MockUsers.sarah,
        createdAt: pastDate(daysAgo: 2),
        requirements: ["Must visit all 5 buildings", "Get permission from front desk", "Photo proof of delivery"]
    )

    public static let marketResearchMuellerArea = AgentTask(
        id: "task-009",
        title: "Market Research - Mueller Development",
        description: "Compile a comprehensive market analysis for the Mueller development area. Include recent sales data, current listings, price per square foot trends, and days on market. Deliver as a formatted PDF report.",
        category: .research,
        status: .assigned,
        address: "4550 Mueller Blvd",
        city: "Austin",
        state: "TX",
        zipCode: "78723",
        latitude: 30.2984,
        longitude: -97.7055,
        compensation: 110,
        estimatedDuration: "3 hours",
        postedBy: MockUsers.david,
        assignedTo: MockUsers.nina,
        createdAt: pastDate(daysAgo: 3),
        scheduledFor: date(daysFromNow: 2, hour: 9),
        requirements: ["PDF report format", "Include last 6 months of data", "Comparative analysis with adjacent neighborhoods"]
    )

    public static let openHouseWestLake = AgentTask(
        id: "task-010",
        title: "Open House at 678 Westlake Dr",
        description: "Host an open house for a stunning 5BR/4BA Westlake Hills property with panoramic views. High-end listing at $2.1M. Must present professionally and be knowledgeable about luxury home features. Catering will be provided.",
        category: .openHouse,
        status: .open,
        address: "678 Westlake Dr",
        city: "Austin",
        state: "TX",
        zipCode: "78746",
        latitude: 30.3167,
        longitude: -97.8103,
        compensation: 200,
        estimatedDuration: "4 hours",
        postedBy: MockUsers.jessica,
        createdAt: pastDate(daysAgo: 1),
        scheduledFor: date(daysFromNow: 6, hour: 12),
        requirements: ["Luxury property experience preferred", "Professional attire", "Arrive 45 min early"]
    )

    public static let photographyEastSide = AgentTask(
        id: "task-011",
        title: "Twilight Photography at 345 Holly St",
        description: "Capture twilight/dusk photos of a recently renovated East Austin bungalow. Interior shots during golden hour and exterior shots at blue hour. This listing needs standout photos to compete in the hot East Side market.",
        category: .photography,
        status: .open,
        address: "345 Holly St",
        city: "Austin",
        state: "TX",
        zipCode: "78702",
        latitude: 30.2601,
        longitude: -97.7268,
        compensation: 140,
        estimatedDuration: "2.5 hours",
        postedBy: MockUsers.emily,
        createdAt: pastDate(daysAgo: 1),
        scheduledFor: date(daysFromNow: 3, hour: 17),
        requirements: ["DSLR with tripod", "Experience with twilight photography", "Deliver within 24 hours"]
    )

    public static let showingRoundRock = AgentTask(
        id: "task-012",
        title: "Multiple Showings in Round Rock",
        description: "Conduct 3 back-to-back showings for a buyer relocating from California. Properties range from $350K-$500K in the Round Rock school district. Buyer is particularly interested in family-friendly neighborhoods near schools.",
        category: .showing,
        status: .completed,
        address: "1200 Gattis School Rd",
        city: "Round Rock",
        state: "TX",
        zipCode: "78664",
        latitude: 30.5083,
        longitude: -97.6789,
        compensation: 120,
        estimatedDuration: "3 hours",
        postedBy: MockUsers.carlos,
        assignedTo: MockUsers.currentUser,
        createdAt: pastDate(daysAgo: 10),
        scheduledFor: pastDate(daysAgo: 7),
        requirements: ["Knowledge of Round Rock schools", "Familiarity with family neighborhoods"]
    )

    public static let signInstallBeeCanyon = AgentTask(
        id: "task-013",
        title: "Sign Install & Removal at Bee Canyon",
        description: "Remove the existing Sold sign and install a new Coming Soon sign at this Bee Cave property. Previous sign post can be reused. Must be completed before 5 PM.",
        category: .signInstall,
        status: .open,
        address: "4100 Bee Canyon Rd",
        city: "Bee Cave",
        state: "TX",
        zipCode: "78738",
        latitude: 30.3082,
        longitude: -97.9399,
        compensation: 45,
        estimatedDuration: "45 minutes",
        postedBy: MockUsers.lisa,
        createdAt: pastDate(daysAgo: 1),
        scheduledFor: date(daysFromNow: 1, hour: 15),
        requirements: ["Must have sign removal tools", "Complete before 5 PM"]
    )

    public static let stagingFullService = AgentTask(
        id: "task-014",
        title: "Full Home Staging - Zilker Area",
        description: "Full staging service for a vacant 3BR/2BA home near Zilker Park. Coordinate furniture rental, set up all rooms, and ensure the property is photo-ready. Budget approved for full staging including artwork and accessories.",
        category: .staging,
        status: .assigned,
        address: "1800 Kinney Ave",
        city: "Austin",
        state: "TX",
        zipCode: "78704",
        latitude: 30.2571,
        longitude: -97.7680,
        compensation: 250,
        estimatedDuration: "6 hours",
        postedBy: MockUsers.sarah,
        assignedTo: MockUsers.currentUser,
        createdAt: pastDate(daysAgo: 4),
        scheduledFor: date(daysFromNow: 7, hour: 8),
        requirements: ["Staging certification required", "Coordinate furniture delivery", "Must be photo-ready by end of day"]
    )

    public static let lockboxMultiple = AgentTask(
        id: "task-015",
        title: "Lockbox Install - 3 New Listings",
        description: "Install Supra eKEY lockboxes on 3 new listings in the South Austin area. Addresses will be provided upon acceptance. All three must be completed in a single trip. Report all access codes.",
        category: .lockbox,
        status: .open,
        address: "2400 S 1st St",
        city: "Austin",
        state: "TX",
        zipCode: "78704",
        latitude: 30.2379,
        longitude: -97.7589,
        compensation: 75,
        estimatedDuration: "1.5 hours",
        postedBy: MockUsers.marcus,
        createdAt: pastDate(daysAgo: 1),
        requirements: ["Supra eKEY access required", "Must complete all 3 in one trip", "Report codes immediately"]
    )

    public static let openHouseDomainArea = AgentTask(
        id: "task-016",
        title: "Open House at The Domain",
        description: "Host an open house for a modern 2BR/2BA condo in the Domain area. Popular with young professionals. Prepare talking points about local amenities, walkability score, and nearby tech employers.",
        category: .openHouse,
        status: .cancelled,
        address: "11511 Domain Dr",
        city: "Austin",
        state: "TX",
        zipCode: "78758",
        latitude: 30.4021,
        longitude: -97.7254,
        compensation: 100,
        estimatedDuration: "3 hours",
        postedBy: MockUsers.david,
        createdAt: pastDate(daysAgo: 8),
        scheduledFor: pastDate(daysAgo: 2),
        requirements: ["Knowledge of Domain area", "Tech industry awareness"]
    )

    public static let researchComparables = AgentTask(
        id: "task-017",
        title: "CMA Report - Travis Heights",
        description: "Prepare a detailed Comparative Market Analysis for a potential listing in Travis Heights. Include 10 recent comps within 0.5 miles, adjustments for features, and a suggested list price range. Client meeting is in 3 days.",
        category: .research,
        status: .open,
        address: "1400 Travis Heights Blvd",
        city: "Austin",
        state: "TX",
        zipCode: "78704",
        latitude: 30.2465,
        longitude: -97.7410,
        compensation: 130,
        estimatedDuration: "4 hours",
        postedBy: MockUsers.nina,
        createdAt: pastDate(daysAgo: 1),
        scheduledFor: date(daysFromNow: 2, hour: 9),
        requirements: ["MLS access required", "Include 10 recent comps", "PDF format with charts"]
    )

    // MARK: - Static Arrays

    public static let allTasks: [AgentTask] = [
        openHouseElmCreek,
        photographyBartonSprings,
        showingLakeAustin,
        signInstallSCongress,
        stagingConsultation,
        lockboxReplacement,
        inspectionPrep,
        flyerDeliveryDowntown,
        marketResearchMuellerArea,
        openHouseWestLake,
        photographyEastSide,
        showingRoundRock,
        signInstallBeeCanyon,
        stagingFullService,
        lockboxMultiple,
        openHouseDomainArea,
        researchComparables
    ]

    public static let openTasks: [AgentTask] = allTasks.filter { $0.status == .open }

    public static let myTasks: [AgentTask] = allTasks.filter { $0.assignedTo?.id == MockUsers.currentUser.id }
}
