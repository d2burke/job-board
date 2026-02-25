import SharedModels

public protocol ProfileServiceProtocol: Sendable {
    func fetchProfile(userId: String) async throws -> User
    func updateProfile(_ user: User) async throws -> User
    func fetchReviews(userId: String) async throws -> [Review]
}
