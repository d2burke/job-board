import Foundation
import Observation
import SharedModels
import Networking

// MARK: - Auth State

public enum AuthState: Equatable {
    case splash
    case onboarding
    case signIn
    case signUp
    case otpVerification
    case profileSetup
    case authenticated(User)

    public static func == (lhs: AuthState, rhs: AuthState) -> Bool {
        switch (lhs, rhs) {
        case (.splash, .splash),
             (.onboarding, .onboarding),
             (.signIn, .signIn),
             (.signUp, .signUp),
             (.otpVerification, .otpVerification),
             (.profileSetup, .profileSetup):
            return true
        case (.authenticated(let a), .authenticated(let b)):
            return a.id == b.id
        default:
            return false
        }
    }
}

// MARK: - AuthViewModel

@Observable
public final class AuthViewModel {

    // MARK: - State

    public var state: AuthState = .splash
    public var email: String = ""
    public var password: String = ""
    public var firstName: String = ""
    public var lastName: String = ""
    public var otp: String = ""
    public var licenseNumber: String = ""
    public var brokerage: String = ""
    public var selectedSpecialties: Set<TaskCategory> = []
    public var isLoading: Bool = false
    public var errorMessage: String?

    // MARK: - Dependencies

    private let authService: AuthServiceProtocol

    // MARK: - Init

    public init(authService: AuthServiceProtocol) {
        self.authService = authService
    }

    // MARK: - Actions

    public func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter your email and password."
            return
        }
        errorMessage = nil
        isLoading = true

        Task { @MainActor in
            do {
                let user = try await authService.signIn(email: email, password: password)
                isLoading = false
                state = .authenticated(user)
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }

    public func signUp() {
        guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        errorMessage = nil
        isLoading = true

        Task { @MainActor in
            do {
                _ = try await authService.signUp(
                    email: email,
                    password: password,
                    firstName: firstName,
                    lastName: lastName
                )
                isLoading = false
                state = .otpVerification
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }

    public func verifyOTP() {
        guard otp.count == 6 else {
            errorMessage = "Please enter the 6-digit verification code."
            return
        }
        errorMessage = nil
        isLoading = true

        // Simulate OTP verification
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1.5))
            isLoading = false
            state = .profileSetup
        }
    }

    public func completeProfileSetup() {
        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            do {
                let user = User(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    phone: "",
                    bio: "",
                    licenseNumber: licenseNumber.isEmpty ? nil : licenseNumber,
                    brokerage: brokerage.isEmpty ? nil : brokerage,
                    specialties: Array(selectedSpecialties)
                )
                let updatedUser = try await authService.updateProfile(user)
                isLoading = false
                state = .authenticated(updatedUser)
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }

    public func skipToSignIn() {
        errorMessage = nil
        state = .signIn
    }

    public func goToOnboarding() {
        errorMessage = nil
        state = .onboarding
    }

    public func goToSignUp() {
        errorMessage = nil
        state = .signUp
    }

    public func goToSignIn() {
        errorMessage = nil
        state = .signIn
    }

    public func skipProfileSetup() {
        let user = User(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: "",
            bio: ""
        )
        state = .authenticated(user)
    }

    public func toggleSpecialty(_ category: TaskCategory) {
        if selectedSpecialties.contains(category) {
            selectedSpecialties.remove(category)
        } else {
            selectedSpecialties.insert(category)
        }
    }
}
