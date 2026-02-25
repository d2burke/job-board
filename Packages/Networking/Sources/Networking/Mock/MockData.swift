import Foundation
import SharedModels

// MARK: - Mock Users

public enum MockUsers {
    public static let currentUser = User(
        id: "user-001",
        firstName: "Sarah",
        lastName: "Chen",
        email: "sarah.chen@example.com",
        phone: "(555) 123-4567",
        avatarURL: nil,
        bio: "Licensed real estate agent with 5 years of experience in residential properties.",
        licenseNumber: "RE-2021-04582",
        brokerage: "Premier Realty Group",
        specialties: [.openHouse, .showing, .photography],
        rating: 4.8,
        reviewCount: 42,
        completedTasks: 87,
        badges: [
            Badge(id: "badge-001", name: "Top Rated", description: "Maintained 4.5+ rating", iconName: "star.fill"),
            Badge(id: "badge-002", name: "Veteran", description: "Completed 50+ tasks", iconName: "medal.fill")
        ],
        isVerified: true,
        joinDate: Calendar.current.date(byAdding: .year, value: -2, to: Date())!
    )

    public static let otherUser1 = User(
        id: "user-002",
        firstName: "Michael",
        lastName: "Rodriguez",
        email: "michael.r@example.com",
        phone: "(555) 234-5678",
        avatarURL: nil,
        bio: "Specializing in commercial real estate and property management.",
        licenseNumber: "RE-2020-03291",
        brokerage: "Urban Nest Realty",
        specialties: [.inspection, .staging, .research],
        rating: 4.6,
        reviewCount: 28,
        completedTasks: 53,
        badges: [
            Badge(id: "badge-003", name: "Quick Responder", description: "Average response under 5 min", iconName: "bolt.fill")
        ],
        isVerified: true,
        joinDate: Calendar.current.date(byAdding: .month, value: -18, to: Date())!
    )

    public static let otherUser2 = User(
        id: "user-003",
        firstName: "Emily",
        lastName: "Johnson",
        email: "emily.j@example.com",
        phone: "(555) 345-6789",
        avatarURL: nil,
        bio: "New agent eager to learn and grow in the real estate industry.",
        specialties: [.flyerDelivery, .signInstall, .lockbox],
        rating: 4.3,
        reviewCount: 12,
        completedTasks: 19,
        badges: [],
        isVerified: false,
        joinDate: Calendar.current.date(byAdding: .month, value: -6, to: Date())!
    )

    public static let otherUser3 = User(
        id: "user-004",
        firstName: "David",
        lastName: "Kim",
        email: "david.kim@example.com",
        phone: "(555) 456-7890",
        avatarURL: nil,
        bio: "Photography specialist with a passion for real estate marketing.",
        licenseNumber: "RE-2019-01843",
        brokerage: "Skyline Properties",
        specialties: [.photography, .staging, .openHouse],
        rating: 4.9,
        reviewCount: 65,
        completedTasks: 112,
        badges: [
            Badge(id: "badge-004", name: "Elite Agent", description: "Completed 100+ tasks", iconName: "crown.fill"),
            Badge(id: "badge-005", name: "Top Rated", description: "Maintained 4.5+ rating", iconName: "star.fill")
        ],
        isVerified: true,
        joinDate: Calendar.current.date(byAdding: .year, value: -3, to: Date())!
    )

    public static let allUsers: [User] = [currentUser, otherUser1, otherUser2, otherUser3]
}

// MARK: - Mock Tasks

public enum MockTasks {
    public static let allTasks: [AgentTask] = [
        AgentTask(
            id: "task-001",
            title: "Open House at 123 Oak Street",
            description: "Host an open house for a beautiful 3-bedroom colonial home. Greet visitors, provide property information sheets, and collect contact details.",
            category: .openHouse,
            status: .open,
            address: "123 Oak Street",
            city: "Springfield",
            state: "IL",
            zipCode: "62701",
            latitude: 39.7817,
            longitude: -89.6501,
            compensation: 150.0,
            estimatedDuration: "3 hours",
            postedBy: MockUsers.otherUser1,
            createdAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            scheduledFor: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
            requirements: ["Licensed agent", "Professional attire"]
        ),
        AgentTask(
            id: "task-002",
            title: "Property Photography - Lakeside Condo",
            description: "Take professional listing photos of a 2-bedroom lakeside condo. Include exterior, all rooms, and amenity areas.",
            category: .photography,
            status: .open,
            address: "456 Lake View Drive",
            city: "Springfield",
            state: "IL",
            zipCode: "62702",
            latitude: 39.7900,
            longitude: -89.6440,
            compensation: 200.0,
            estimatedDuration: "2 hours",
            postedBy: MockUsers.otherUser3,
            createdAt: Calendar.current.date(byAdding: .hour, value: -12, to: Date())!,
            scheduledFor: Calendar.current.date(byAdding: .day, value: 2, to: Date()),
            requirements: ["DSLR camera required", "Photo editing skills"]
        ),
        AgentTask(
            id: "task-003",
            title: "Home Inspection Walkthrough",
            description: "Accompany the home inspector at a property inspection. Take notes, document findings, and provide a summary report.",
            category: .inspection,
            status: .assigned,
            address: "789 Elm Avenue",
            city: "Springfield",
            state: "IL",
            zipCode: "62703",
            latitude: 39.7750,
            longitude: -89.6550,
            compensation: 100.0,
            estimatedDuration: "2.5 hours",
            postedBy: MockUsers.otherUser1,
            assignedTo: MockUsers.currentUser,
            createdAt: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            scheduledFor: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            requirements: ["Note-taking supplies"]
        ),
        AgentTask(
            id: "task-004",
            title: "Install For Sale Sign",
            description: "Install a for-sale sign at the property. Sign and post will be provided at the brokerage office for pickup.",
            category: .signInstall,
            status: .open,
            address: "321 Pine Road",
            city: "Springfield",
            state: "IL",
            zipCode: "62704",
            latitude: 39.7680,
            longitude: -89.6600,
            compensation: 50.0,
            estimatedDuration: "30 minutes",
            postedBy: MockUsers.otherUser2,
            createdAt: Calendar.current.date(byAdding: .hour, value: -6, to: Date())!,
            requirements: ["Vehicle for transport", "Basic tools"]
        ),
        AgentTask(
            id: "task-005",
            title: "Stage Living Room and Kitchen",
            description: "Stage the living room and kitchen of a vacant property using provided furniture and decor items.",
            category: .staging,
            status: .open,
            address: "654 Maple Court",
            city: "Springfield",
            state: "IL",
            zipCode: "62701",
            latitude: 39.7830,
            longitude: -89.6480,
            compensation: 300.0,
            estimatedDuration: "4 hours",
            postedBy: MockUsers.otherUser3,
            createdAt: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            scheduledFor: Calendar.current.date(byAdding: .day, value: 5, to: Date()),
            requirements: ["Staging experience", "Vehicle for transport"]
        ),
        AgentTask(
            id: "task-006",
            title: "Deliver Flyers to Neighborhood",
            description: "Distribute 200 property flyers to homes within a 5-block radius of the listing. Door hangers provided.",
            category: .flyerDelivery,
            status: .completed,
            address: "100 Main Street",
            city: "Springfield",
            state: "IL",
            zipCode: "62702",
            latitude: 39.7870,
            longitude: -89.6510,
            compensation: 75.0,
            estimatedDuration: "2 hours",
            postedBy: MockUsers.currentUser,
            assignedTo: MockUsers.otherUser2,
            createdAt: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
            requirements: ["Comfortable walking shoes"]
        ),
        AgentTask(
            id: "task-007",
            title: "Showing for Buyer Client",
            description: "Show 3 properties to a pre-qualified buyer. Property addresses and buyer contact info will be provided upon assignment.",
            category: .showing,
            status: .inProgress,
            address: "222 Broadway",
            city: "Springfield",
            state: "IL",
            zipCode: "62703",
            latitude: 39.7760,
            longitude: -89.6530,
            compensation: 125.0,
            estimatedDuration: "2 hours",
            postedBy: MockUsers.currentUser,
            assignedTo: MockUsers.otherUser1,
            createdAt: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            scheduledFor: Date(),
            requirements: ["Licensed agent", "MLS access"]
        ),
        AgentTask(
            id: "task-008",
            title: "Replace Lockbox at 555 Cedar Lane",
            description: "Replace the current lockbox with a new Supra eKEY lockbox. Old lockbox combination will be provided.",
            category: .lockbox,
            status: .open,
            address: "555 Cedar Lane",
            city: "Springfield",
            state: "IL",
            zipCode: "62704",
            latitude: 39.7700,
            longitude: -89.6580,
            compensation: 40.0,
            estimatedDuration: "20 minutes",
            postedBy: MockUsers.otherUser1,
            createdAt: Calendar.current.date(byAdding: .hour, value: -3, to: Date())!,
            requirements: ["Supra eKEY access"]
        )
    ]
}

// MARK: - Mock Messages

public enum MockMessages {
    public static let allConversations: [Conversation] = [
        Conversation(
            id: "conv-001",
            participants: [MockUsers.currentUser, MockUsers.otherUser1],
            lastMessage: "Great, I'll be there at 2 PM tomorrow.",
            lastMessageAt: Calendar.current.date(byAdding: .hour, value: -1, to: Date())!,
            unreadCount: 2,
            taskTitle: "Home Inspection Walkthrough"
        ),
        Conversation(
            id: "conv-002",
            participants: [MockUsers.currentUser, MockUsers.otherUser2],
            lastMessage: "The flyers have been delivered. Here's a photo of the route covered.",
            lastMessageAt: Calendar.current.date(byAdding: .hour, value: -5, to: Date())!,
            unreadCount: 0,
            taskTitle: "Deliver Flyers to Neighborhood"
        ),
        Conversation(
            id: "conv-003",
            participants: [MockUsers.currentUser, MockUsers.otherUser3],
            lastMessage: "Can you send me the property details for the staging job?",
            lastMessageAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            unreadCount: 1,
            taskTitle: "Stage Living Room and Kitchen"
        )
    ]

    public static let allMessages: [String: [Message]] = [
        "conv-001": [
            Message(
                id: "msg-001",
                conversationId: "conv-001",
                senderId: MockUsers.otherUser1.id,
                text: "Hi Sarah, I've assigned you to the inspection walkthrough at 789 Elm Avenue.",
                timestamp: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                isRead: true
            ),
            Message(
                id: "msg-002",
                conversationId: "conv-001",
                senderId: MockUsers.currentUser.id,
                text: "Thanks Michael! What time should I be there?",
                timestamp: Calendar.current.date(byAdding: .hour, value: -20, to: Date())!,
                isRead: true
            ),
            Message(
                id: "msg-003",
                conversationId: "conv-001",
                senderId: MockUsers.otherUser1.id,
                text: "The inspector will arrive at 2 PM. Please be there 15 minutes early.",
                timestamp: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!,
                isRead: false
            ),
            Message(
                id: "msg-004",
                conversationId: "conv-001",
                senderId: MockUsers.currentUser.id,
                text: "Great, I'll be there at 2 PM tomorrow.",
                timestamp: Calendar.current.date(byAdding: .hour, value: -1, to: Date())!,
                isRead: true
            )
        ],
        "conv-002": [
            Message(
                id: "msg-005",
                conversationId: "conv-002",
                senderId: MockUsers.currentUser.id,
                text: "Hi Emily, are you available to deliver flyers this weekend?",
                timestamp: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                isRead: true
            ),
            Message(
                id: "msg-006",
                conversationId: "conv-002",
                senderId: MockUsers.otherUser2.id,
                text: "Yes! I can do Saturday morning.",
                timestamp: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                isRead: true
            ),
            Message(
                id: "msg-007",
                conversationId: "conv-002",
                senderId: MockUsers.otherUser2.id,
                text: "The flyers have been delivered. Here's a photo of the route covered.",
                timestamp: Calendar.current.date(byAdding: .hour, value: -5, to: Date())!,
                isRead: true
            )
        ],
        "conv-003": [
            Message(
                id: "msg-008",
                conversationId: "conv-003",
                senderId: MockUsers.otherUser3.id,
                text: "Hi Sarah, I saw you have experience with staging. I have a job coming up.",
                timestamp: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                isRead: true
            ),
            Message(
                id: "msg-009",
                conversationId: "conv-003",
                senderId: MockUsers.currentUser.id,
                text: "Sure, David! I'd be interested. What's the property like?",
                timestamp: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                isRead: true
            ),
            Message(
                id: "msg-010",
                conversationId: "conv-003",
                senderId: MockUsers.otherUser3.id,
                text: "Can you send me the property details for the staging job?",
                timestamp: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                isRead: false
            )
        ]
    ]
}

// MARK: - Mock Reviews

public enum MockReviews {
    public static let allReviews: [Review] = [
        Review(
            id: "review-001",
            taskId: "task-006",
            reviewerId: MockUsers.otherUser2.id,
            revieweeId: MockUsers.currentUser.id,
            rating: 5.0,
            comment: "Sarah was great to work with! Clear instructions and prompt payment.",
            createdAt: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
            reviewerName: MockUsers.otherUser2.fullName
        ),
        Review(
            id: "review-002",
            taskId: "task-007",
            reviewerId: MockUsers.otherUser1.id,
            revieweeId: MockUsers.currentUser.id,
            rating: 4.5,
            comment: "Very professional and thorough. Would hire again.",
            createdAt: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
            reviewerName: MockUsers.otherUser1.fullName
        ),
        Review(
            id: "review-003",
            taskId: "task-003",
            reviewerId: MockUsers.currentUser.id,
            revieweeId: MockUsers.otherUser1.id,
            rating: 4.8,
            comment: "Michael provided excellent instructions and was responsive throughout.",
            createdAt: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            reviewerName: MockUsers.currentUser.fullName
        ),
        Review(
            id: "review-004",
            taskId: "task-002",
            reviewerId: MockUsers.otherUser3.id,
            revieweeId: MockUsers.currentUser.id,
            rating: 5.0,
            comment: "Outstanding work on the photography. The photos really made the listing shine.",
            createdAt: Calendar.current.date(byAdding: .day, value: -15, to: Date())!,
            reviewerName: MockUsers.otherUser3.fullName
        ),
        Review(
            id: "review-005",
            taskId: "task-004",
            reviewerId: MockUsers.currentUser.id,
            revieweeId: MockUsers.otherUser2.id,
            rating: 4.0,
            comment: "Emily was punctual and completed the sign installation quickly.",
            createdAt: Calendar.current.date(byAdding: .day, value: -8, to: Date())!,
            reviewerName: MockUsers.currentUser.fullName
        )
    ]
}
