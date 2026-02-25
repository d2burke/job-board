import Foundation
import SharedModels
import Networking

/// A mock implementation of ``AuthServiceProtocol`` used for previews and tests.
public struct MockAuthService: AuthServiceProtocol {

    public init() {}

    public func signIn(email: String, password: String) async throws -> User {
        try await Task.sleep(for: .seconds(1))
        return MockUsers.currentUser
    }

    public func signUp(email: String, password: String, firstName: String, lastName: String) async throws -> User {
        try await Task.sleep(for: .seconds(1))
        return User(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: "",
            bio: ""
        )
    }

    public func signOut() async throws {
        try await Task.sleep(for: .seconds(0.5))
    }

    public func currentUser() async -> User? {
        return MockUsers.currentUser
    }

    public func updateProfile(_ user: User) async throws -> User {
        try await Task.sleep(for: .seconds(1))
        return user
    }
}
