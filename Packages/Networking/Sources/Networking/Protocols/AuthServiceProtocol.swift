import SharedModels

public protocol AuthServiceProtocol: Sendable {
    func signIn(email: String, password: String) async throws -> User
    func signUp(email: String, password: String, firstName: String, lastName: String) async throws -> User
    func signOut() async throws
    func currentUser() async -> User?
    func updateProfile(_ user: User) async throws -> User
}
