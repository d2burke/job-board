import Foundation

public enum MockMessages {
    // MARK: - Date Helpers

    private static func minutesAgo(_ minutes: Int) -> Date {
        Calendar.current.date(byAdding: .minute, value: -minutes, to: Date())!
    }

    private static func hoursAgo(_ hours: Int) -> Date {
        Calendar.current.date(byAdding: .hour, value: -hours, to: Date())!
    }

    private static func daysAgo(_ days: Int, hour: Int = 10, minute: Int = 0) -> Date {
        let base = Calendar.current.date(byAdding: .day, value: -days, to: Date())!
        var components = Calendar.current.dateComponents([.year, .month, .day], from: base)
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components)!
    }

    // MARK: - Conversation 1: Alex & Sarah about Open House

    private static let conv1Messages: [Message] = [
        Message(
            id: "msg-101",
            conversationId: "conv-001",
            senderId: MockUsers.sarah.id,
            text: "Hi Alex! I saw you're available this Saturday. Would you be able to host the open house at 1204 Elm Creek? It's a gorgeous property.",
            timestamp: daysAgo(2, hour: 9, minute: 15),
            isRead: true
        ),
        Message(
            id: "msg-102",
            conversationId: "conv-001",
            senderId: MockUsers.currentUser.id,
            text: "Hey Sarah! Saturday works great for me. What time are you thinking? I saw the listing — that kitchen remodel looks amazing.",
            timestamp: daysAgo(2, hour: 9, minute: 32),
            isRead: true
        ),
        Message(
            id: "msg-103",
            conversationId: "conv-001",
            senderId: MockUsers.sarah.id,
            text: "The open house is 1-4 PM, but I'd love for you to arrive by 12:30 to set up. I'll have sign-in tablets, flyers, and a refreshment spread delivered by noon.",
            timestamp: daysAgo(2, hour: 9, minute: 45),
            isRead: true
        ),
        Message(
            id: "msg-104",
            conversationId: "conv-001",
            senderId: MockUsers.currentUser.id,
            text: "Perfect, 12:30 works. Any particular talking points you want me to emphasize? I know the Elm Creek area well.",
            timestamp: daysAgo(2, hour: 10, minute: 3),
            isRead: true
        ),
        Message(
            id: "msg-105",
            conversationId: "conv-001",
            senderId: MockUsers.sarah.id,
            text: "Definitely highlight the new kitchen, the mature oak trees in the backyard, and the proximity to Tarrytown Elementary. List price is $675K. I'll send you the full feature sheet tonight.",
            timestamp: daysAgo(2, hour: 10, minute: 18),
            isRead: true
        ),
        Message(
            id: "msg-106",
            conversationId: "conv-001",
            senderId: MockUsers.currentUser.id,
            text: "Got it! I'll review the feature sheet and be fully prepped. Thanks for thinking of me for this one!",
            timestamp: daysAgo(2, hour: 10, minute: 25),
            isRead: true
        ),
        Message(
            id: "msg-107",
            conversationId: "conv-001",
            senderId: MockUsers.sarah.id,
            text: "Of course! You always do a great job. I just emailed you the feature sheet and comps. Let me know if you have any questions before Saturday.",
            timestamp: daysAgo(1, hour: 20, minute: 15),
            isRead: true
        )
    ]

    // MARK: - Conversation 2: Alex & Nina about Inspection

    private static let conv2Messages: [Message] = [
        Message(
            id: "msg-201",
            conversationId: "conv-002",
            senderId: MockUsers.nina.id,
            text: "Alex, I need someone reliable for a pre-inspection walkthrough at 1100 S Lamar. The official inspection is next week and my client is nervous. Can you take a look?",
            timestamp: daysAgo(3, hour: 14, minute: 0),
            isRead: true
        ),
        Message(
            id: "msg-202",
            conversationId: "conv-002",
            senderId: MockUsers.currentUser.id,
            text: "Absolutely, Nina. I've done a few pre-inspections before. When do you need me there?",
            timestamp: daysAgo(3, hour: 14, minute: 22),
            isRead: true
        ),
        Message(
            id: "msg-203",
            conversationId: "conv-002",
            senderId: MockUsers.nina.id,
            text: "Would today at 2 PM work? I know it's short notice. The property is a 1960s build so pay special attention to the plumbing and electrical. The HVAC was replaced 3 years ago so that should be fine.",
            timestamp: daysAgo(3, hour: 14, minute: 35),
            isRead: true
        ),
        Message(
            id: "msg-204",
            conversationId: "conv-002",
            senderId: MockUsers.currentUser.id,
            text: "Today at 2 PM works! I'll check plumbing, electrical, foundation, roof condition, and all the usual suspects. I'll document everything with photos.",
            timestamp: daysAgo(3, hour: 14, minute: 48),
            isRead: true
        ),
        Message(
            id: "msg-205",
            conversationId: "conv-002",
            senderId: MockUsers.nina.id,
            text: "You're a lifesaver. The lockbox code is 7890. Please lock up when you're done and text me when you're finished. I'll be in a meeting until 4.",
            timestamp: daysAgo(3, hour: 14, minute: 55),
            isRead: true
        ),
        Message(
            id: "msg-206",
            conversationId: "conv-002",
            senderId: MockUsers.currentUser.id,
            text: "Just finished the walkthrough. Overall the property is in good shape. Found a slow drip under the master bath sink and one outlet in the garage isn't working. Everything else checks out. Sending you the full report with photos now.",
            timestamp: daysAgo(3, hour: 16, minute: 30),
            isRead: true
        ),
        Message(
            id: "msg-207",
            conversationId: "conv-002",
            senderId: MockUsers.nina.id,
            text: "That's great news overall. The minor stuff we can address before the official inspection. Thanks for the quick turnaround, Alex. Sending payment now!",
            timestamp: daysAgo(3, hour: 17, minute: 10),
            isRead: true
        ),
        Message(
            id: "msg-208",
            conversationId: "conv-002",
            senderId: MockUsers.currentUser.id,
            text: "Happy to help! Let me know if you need anything else before the official inspection.",
            timestamp: daysAgo(3, hour: 17, minute: 20),
            isRead: true
        )
    ]

    // MARK: - Conversation 3: Alex & Emily about Photography

    private static let conv3Messages: [Message] = [
        Message(
            id: "msg-301",
            conversationId: "conv-003",
            senderId: MockUsers.emily.id,
            text: "Hey Alex! I know you do great photo work. I have a twilight shoot at 345 Holly St coming up — any interest?",
            timestamp: hoursAgo(5),
            isRead: true
        ),
        Message(
            id: "msg-302",
            conversationId: "conv-003",
            senderId: MockUsers.currentUser.id,
            text: "Thanks Emily! I'd love to take that on. I just upgraded my lens collection — perfect timing. When is the shoot?",
            timestamp: hoursAgo(4),
            isRead: true
        ),
        Message(
            id: "msg-303",
            conversationId: "conv-003",
            senderId: MockUsers.emily.id,
            text: "It's this Thursday at 5 PM for golden hour interior shots, then we'll transition to exterior blue hour shots around 7:30. The home is an adorable renovated bungalow with great curb appeal.",
            timestamp: hoursAgo(3),
            isRead: true
        ),
        Message(
            id: "msg-304",
            conversationId: "conv-003",
            senderId: MockUsers.currentUser.id,
            text: "That sounds perfect. I'll bring my tripod and the 16-35mm wide angle. Do you want drone shots too? I got my Part 107 last month.",
            timestamp: hoursAgo(2),
            isRead: true
        ),
        Message(
            id: "msg-305",
            conversationId: "conv-003",
            senderId: MockUsers.emily.id,
            text: "Drone shots would be amazing! Let's add those in. I'll bump the compensation to $160 to cover the aerial work. Can you deliver everything edited within 24 hours?",
            timestamp: hoursAgo(1),
            isRead: false
        ),
        Message(
            id: "msg-306",
            conversationId: "conv-003",
            senderId: MockUsers.currentUser.id,
            text: "24-hour turnaround is no problem. I'll have everything edited and in a shared Dropbox folder by Friday evening. Looking forward to it!",
            timestamp: minutesAgo(30),
            isRead: false
        )
    ]

    // MARK: - Conversation 4: Alex & Carlos about Showing

    private static let conv4Messages: [Message] = [
        Message(
            id: "msg-401",
            conversationId: "conv-004",
            senderId: MockUsers.carlos.id,
            text: "Alex, I have a buyer couple from Dallas looking at the Lake Austin Blvd property this weekend. I'm double-booked — could you handle the showing?",
            timestamp: daysAgo(1, hour: 8, minute: 0),
            isRead: true
        ),
        Message(
            id: "msg-402",
            conversationId: "conv-004",
            senderId: MockUsers.currentUser.id,
            text: "I'd be happy to, Carlos. Lake Austin is one of my favorite areas. What should I know about the buyers?",
            timestamp: daysAgo(1, hour: 8, minute: 30),
            isRead: true
        ),
        Message(
            id: "msg-403",
            conversationId: "conv-004",
            senderId: MockUsers.carlos.id,
            text: "They're pre-approved for $1.2M. Moving from Dallas for a tech job. Big concerns about flood zones and the HOA rules around the boat dock. The wife works from home so the office space is a big selling point.",
            timestamp: daysAgo(1, hour: 9, minute: 0),
            isRead: true
        ),
        Message(
            id: "msg-404",
            conversationId: "conv-004",
            senderId: MockUsers.currentUser.id,
            text: "Good to know. I'll pull the flood zone maps and HOA docs beforehand. The home office in that property has great natural light — I'll make sure to highlight it.",
            timestamp: daysAgo(1, hour: 9, minute: 15),
            isRead: true
        ),
        Message(
            id: "msg-405",
            conversationId: "conv-004",
            senderId: MockUsers.carlos.id,
            text: "Perfect. The showing is Saturday at 2 PM. I'll text you their contact info. Thanks for covering — I owe you one!",
            timestamp: daysAgo(1, hour: 9, minute: 30),
            isRead: true
        )
    ]

    // MARK: - Conversations

    public static let allConversations: [Conversation] = [
        Conversation(
            id: "conv-001",
            participants: [MockUsers.currentUser, MockUsers.sarah],
            lastMessage: "Of course! You always do a great job. I just emailed you the feature sheet and comps. Let me know if you have any questions before Saturday.",
            lastMessageAt: daysAgo(1, hour: 20, minute: 15),
            unreadCount: 0,
            taskTitle: "Open House at 1204 Elm Creek"
        ),
        Conversation(
            id: "conv-002",
            participants: [MockUsers.currentUser, MockUsers.nina],
            lastMessage: "Happy to help! Let me know if you need anything else before the official inspection.",
            lastMessageAt: daysAgo(3, hour: 17, minute: 20),
            unreadCount: 0,
            taskTitle: "Pre-Inspection Property Check"
        ),
        Conversation(
            id: "conv-003",
            participants: [MockUsers.currentUser, MockUsers.emily],
            lastMessage: "24-hour turnaround is no problem. I'll have everything edited and in a shared Dropbox folder by Friday evening. Looking forward to it!",
            lastMessageAt: minutesAgo(30),
            unreadCount: 1,
            taskTitle: "Twilight Photography at 345 Holly St"
        ),
        Conversation(
            id: "conv-004",
            participants: [MockUsers.currentUser, MockUsers.carlos],
            lastMessage: "Perfect. The showing is Saturday at 2 PM. I'll text you their contact info. Thanks for covering — I owe you one!",
            lastMessageAt: daysAgo(1, hour: 9, minute: 30),
            unreadCount: 0,
            taskTitle: "Weekend Showing at 456 Lake Austin"
        )
    ]

    // MARK: - Helper

    public static func messagesFor(conversationId: String) -> [Message] {
        switch conversationId {
        case "conv-001": return conv1Messages
        case "conv-002": return conv2Messages
        case "conv-003": return conv3Messages
        case "conv-004": return conv4Messages
        default: return []
        }
    }
}
