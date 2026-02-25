import Foundation

public enum MockReviews {
    // MARK: - Date Helper

    private static func daysAgo(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -days, to: Date())!
    }

    // MARK: - Reviews

    public static let allReviews: [Review] = [
        // Reviews FOR currentUser (Alex Morgan)
        Review(
            id: "review-001",
            taskId: "task-012",
            reviewerId: MockUsers.carlos.id,
            revieweeId: MockUsers.currentUser.id,
            rating: 5.0,
            comment: "Alex did an outstanding job with the Round Rock showings. He was incredibly prepared with neighborhood data, school ratings, and commute times. The buyers were impressed and are moving forward with an offer!",
            createdAt: daysAgo(7),
            reviewerName: MockUsers.carlos.fullName,
            reviewerAvatarURL: MockUsers.carlos.avatarURL
        ),
        Review(
            id: "review-002",
            taskId: "task-completed-001",
            reviewerId: MockUsers.sarah.id,
            revieweeId: MockUsers.currentUser.id,
            rating: 5.0,
            comment: "Alex hosted a flawless open house last month. Professional, engaging with visitors, and followed up with detailed notes on every attendee. Will definitely hire again.",
            createdAt: daysAgo(14),
            reviewerName: MockUsers.sarah.fullName,
            reviewerAvatarURL: MockUsers.sarah.avatarURL
        ),
        Review(
            id: "review-003",
            taskId: "task-completed-002",
            reviewerId: MockUsers.jessica.id,
            revieweeId: MockUsers.currentUser.id,
            rating: 4.5,
            comment: "Great photography work for the Westlake listing. The twilight shots were stunning. Only minor note — a few interior shots could have been a bit brighter, but overall excellent work.",
            createdAt: daysAgo(21),
            reviewerName: MockUsers.jessica.fullName,
            reviewerAvatarURL: MockUsers.jessica.avatarURL
        ),
        Review(
            id: "review-004",
            taskId: "task-completed-003",
            reviewerId: MockUsers.nina.id,
            revieweeId: MockUsers.currentUser.id,
            rating: 5.0,
            comment: "Alex's pre-inspection report was thorough and well-organized. Caught issues that even I might have missed. His construction knowledge really shows. Highly recommended.",
            createdAt: daysAgo(3),
            reviewerName: MockUsers.nina.fullName,
            reviewerAvatarURL: MockUsers.nina.avatarURL
        ),
        Review(
            id: "review-005",
            taskId: "task-completed-004",
            reviewerId: MockUsers.emily.id,
            revieweeId: MockUsers.currentUser.id,
            rating: 4.0,
            comment: "Alex helped with flyer delivery across downtown. Got it done on time and provided photo proof for every location. Reliable and communicative throughout.",
            createdAt: daysAgo(30),
            reviewerName: MockUsers.emily.fullName,
            reviewerAvatarURL: MockUsers.emily.avatarURL
        ),

        // Reviews FOR other users
        Review(
            id: "review-006",
            taskId: "task-completed-005",
            reviewerId: MockUsers.currentUser.id,
            revieweeId: MockUsers.sarah.id,
            rating: 5.0,
            comment: "Sarah's staging consultation completely transformed the look and feel of my listing. Her eye for design is unmatched. The property went under contract in just 4 days after staging!",
            createdAt: daysAgo(18),
            reviewerName: MockUsers.currentUser.fullName,
            reviewerAvatarURL: MockUsers.currentUser.avatarURL
        ),
        Review(
            id: "review-007",
            taskId: "task-completed-006",
            reviewerId: MockUsers.currentUser.id,
            revieweeId: MockUsers.marcus.id,
            rating: 4.5,
            comment: "Marcus handled the lockbox installations efficiently. All three were done in a single trip and he reported the codes right away. Very dependable.",
            createdAt: daysAgo(25),
            reviewerName: MockUsers.currentUser.fullName,
            reviewerAvatarURL: MockUsers.currentUser.avatarURL
        ),
        Review(
            id: "review-008",
            taskId: "task-completed-007",
            reviewerId: MockUsers.david.id,
            revieweeId: MockUsers.emily.id,
            rating: 5.0,
            comment: "Emily's listing photos were absolutely phenomenal. The wide-angle shots made every room look spacious and inviting. Best real estate photography I've seen in Austin.",
            createdAt: daysAgo(12),
            reviewerName: MockUsers.david.fullName,
            reviewerAvatarURL: MockUsers.david.avatarURL
        ),
        Review(
            id: "review-009",
            taskId: "task-completed-008",
            reviewerId: MockUsers.jessica.id,
            revieweeId: MockUsers.carlos.id,
            rating: 5.0,
            comment: "Carlos hosted one of the best open houses I've ever seen. His energy and knowledge of the neighborhood drew in 40+ visitors. Three offers came in that same weekend.",
            createdAt: daysAgo(9),
            reviewerName: MockUsers.jessica.fullName,
            reviewerAvatarURL: MockUsers.jessica.avatarURL
        ),
        Review(
            id: "review-010",
            taskId: "task-completed-009",
            reviewerId: MockUsers.sarah.id,
            revieweeId: MockUsers.ryan.id,
            rating: 4.0,
            comment: "Ryan was prompt and efficient with the sign installations. He's new but clearly dedicated to doing quality work. The signs were perfectly aligned and he sent photos right away.",
            createdAt: daysAgo(16),
            reviewerName: MockUsers.sarah.fullName,
            reviewerAvatarURL: MockUsers.sarah.avatarURL
        ),
        Review(
            id: "review-011",
            taskId: "task-completed-010",
            reviewerId: MockUsers.carlos.id,
            revieweeId: MockUsers.nina.id,
            rating: 5.0,
            comment: "Nina's market research report was incredibly detailed and professionally formatted. The comparative analysis gave us exactly the insights we needed to price the listing competitively.",
            createdAt: daysAgo(5),
            reviewerName: MockUsers.carlos.fullName,
            reviewerAvatarURL: MockUsers.carlos.avatarURL
        ),
        Review(
            id: "review-012",
            taskId: "task-completed-011",
            reviewerId: MockUsers.marcus.id,
            revieweeId: MockUsers.lisa.id,
            rating: 4.5,
            comment: "Lisa did a wonderful job with the weekend showing. She was warm, knowledgeable about the Cedar Park area, and the buyers felt very comfortable. Great first impression.",
            createdAt: daysAgo(20),
            reviewerName: MockUsers.marcus.fullName,
            reviewerAvatarURL: MockUsers.marcus.avatarURL
        )
    ]

    // MARK: - Helper

    public static func reviewsFor(userId: String) -> [Review] {
        allReviews.filter { $0.revieweeId == userId }
    }
}
