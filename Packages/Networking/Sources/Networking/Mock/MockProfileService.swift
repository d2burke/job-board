import Foundation
import SharedModels

@MainActor
public final class MockProfileService: ProfileServiceProtocol {
    private var users: [String: User]

    public init() {
        var userDict: [String: User] = [:]
        for user in MockUsers.allUsers {
            userDict[user.id] = user
        }
        self.users = userDict
    }

    nonisolated public func fetchProfile(userId: String) async throws -> User {
        try await Task.sleep(for: .milliseconds(300))
        let allUsers = await MainActor.run { self.users }
        guard let user = allUsers[userId] else {
            throw NetworkingError.notFound
        }
        return user
    }

    nonisolated public func updateProfile(_ user: User) async throws -> User {
        try await Task.sleep(for: .milliseconds(400))
        await MainActor.run { self.users[user.id] = user }
        return user
    }

    nonisolated public func fetchReviews(userId: String) async throws -> [Review] {
        try await Task.sleep(for: .milliseconds(300))
        return MockReviews.allReviews.filter { $0.revieweeId == userId }
    }
}
