import Testing
import Foundation
@testable import Authentication
import SharedModels
import Networking

// MARK: - Instant Mock Auth Service

struct InstantMockAuthService: AuthServiceProtocol {
    var shouldFail = false

    func signIn(email: String, password: String) async throws -> User {
        if shouldFail { throw MockAuthError.invalidCredentials }
        return MockUsers.currentUser
    }

    func signUp(email: String, password: String, firstName: String, lastName: String) async throws -> User {
        if shouldFail { throw MockAuthError.signUpFailed }
        return User(firstName: firstName, lastName: lastName, email: email, phone: "", bio: "")
    }

    func signOut() async throws {}
    func currentUser() async -> User? { MockUsers.currentUser }
    func updateProfile(_ user: User) async throws -> User { user }
}

enum MockAuthError: Error, LocalizedError {
    case invalidCredentials
    case signUpFailed

    var errorDescription: String? {
        switch self {
        case .invalidCredentials: return "Invalid credentials"
        case .signUpFailed: return "Sign up failed"
        }
    }
}

// MARK: - Tests

@Suite("AuthViewModel Tests")
struct AuthViewModelTests {

    @Test("Initial state is splash")
    func initialState() {
        let viewModel = AuthViewModel(authService: InstantMockAuthService())
        #expect(viewModel.state == .splash)
    }

    @Test("skipToSignIn transitions to signIn state")
    func skipToSignIn() {
        let viewModel = AuthViewModel(authService: InstantMockAuthService())
        viewModel.skipToSignIn()
        #expect(viewModel.state == .signIn)
    }

    @Test("goToOnboarding transitions to onboarding state")
    func goToOnboarding() {
        let viewModel = AuthViewModel(authService: InstantMockAuthService())
        viewModel.goToOnboarding()
        #expect(viewModel.state == .onboarding)
    }

    @Test("goToSignUp transitions to signUp state")
    func goToSignUp() {
        let viewModel = AuthViewModel(authService: InstantMockAuthService())
        viewModel.goToSignUp()
        #expect(viewModel.state == .signUp)
    }

    @Test("signIn with empty fields shows error")
    func signInEmptyFields() {
        let viewModel = AuthViewModel(authService: InstantMockAuthService())
        viewModel.signIn()
        #expect(viewModel.errorMessage != nil)
    }

    @Test("signUp with empty fields shows error")
    func signUpEmptyFields() {
        let viewModel = AuthViewModel(authService: InstantMockAuthService())
        viewModel.signUp()
        #expect(viewModel.errorMessage != nil)
    }

    @Test("verifyOTP with short code shows error")
    func verifyOTPShortCode() {
        let viewModel = AuthViewModel(authService: InstantMockAuthService())
        viewModel.otp = "123"
        viewModel.verifyOTP()
        #expect(viewModel.errorMessage != nil)
    }

    @Test("toggleSpecialty adds and removes categories")
    func toggleSpecialty() {
        let viewModel = AuthViewModel(authService: InstantMockAuthService())
        viewModel.toggleSpecialty(.openHouse)
        #expect(viewModel.selectedSpecialties.contains(.openHouse))
        viewModel.toggleSpecialty(.openHouse)
        #expect(!viewModel.selectedSpecialties.contains(.openHouse))
    }

    @Test("skipProfileSetup transitions to authenticated")
    func skipProfileSetup() {
        let viewModel = AuthViewModel(authService: InstantMockAuthService())
        viewModel.firstName = "Test"
        viewModel.lastName = "User"
        viewModel.email = "test@example.com"
        viewModel.skipProfileSetup()
        if case .authenticated = viewModel.state {
            // expected
        } else {
            Issue.record("Expected authenticated state")
        }
    }

    @Test("Error message clears on state transition")
    func errorClearsOnTransition() {
        let viewModel = AuthViewModel(authService: InstantMockAuthService())
        viewModel.errorMessage = "Some error"
        viewModel.goToSignIn()
        #expect(viewModel.errorMessage == nil)
    }
}
