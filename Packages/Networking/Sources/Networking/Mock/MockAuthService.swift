import Foundation
import SharedModels

@MainActor
public final class MockAuthService: AuthServiceProtocol {
    private var loggedInUser: User?

    public init() {
        self.loggedInUser = nil
    }

    nonisolated public func signIn(email: String, password: String) async throws -> User {
        try await Task.sleep(for: .milliseconds(300))
        let user = MockUsers.currentUser
        await MainActor.run { self.loggedInUser = user }
        return user
    }

    nonisolated public func signUp(email: String, password: String, firstName: String, lastName: String) async throws -> User {
        try await Task.sleep(for: .milliseconds(400))
        let newUser = User(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: "",
            bio: "",
            joinDate: Date()
        )
        await MainActor.run { self.loggedInUser = newUser }
        return newUser
    }

    nonisolated public func signOut() async throws {
        try await Task.sleep(for: .milliseconds(300))
        await MainActor.run { self.loggedInUser = nil }
    }

    nonisolated public func currentUser() async -> User? {
        await MainActor.run { self.loggedInUser }
    }

    nonisolated public func updateProfile(_ user: User) async throws -> User {
        try await Task.sleep(for: .milliseconds(300))
        var updatedUser = await MainActor.run { self.loggedInUser ?? user }
        updatedUser.firstName = user.firstName
        updatedUser.lastName = user.lastName
        updatedUser.email = user.email
        updatedUser.phone = user.phone
        updatedUser.bio = user.bio
        updatedUser.avatarURL = user.avatarURL
        updatedUser.licenseNumber = user.licenseNumber
        updatedUser.brokerage = user.brokerage
        updatedUser.specialties = user.specialties
        await MainActor.run { self.loggedInUser = updatedUser }
        return updatedUser
    }
}
