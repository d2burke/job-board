import SwiftUI
import Networking

/// The root entry point for the Authentication feature module.
///
/// Manages the full authentication flow from splash to authenticated state.
/// Switch on `AuthViewModel.state` to present the appropriate screen.
public struct AuthenticationModule: View {

    // MARK: - State

    @State private var viewModel: AuthViewModel

    // MARK: - Init

    public init(authService: AuthServiceProtocol) {
        _viewModel = State(initialValue: AuthViewModel(authService: authService))
    }

    // MARK: - Body

    public var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .splash:
                    WelcomeView(viewModel: viewModel)

                case .onboarding:
                    OnboardingCarousel(viewModel: viewModel)

                case .signIn:
                    SignInView(viewModel: viewModel)

                case .signUp:
                    SignUpView(viewModel: viewModel)

                case .otpVerification:
                    OTPVerificationView(viewModel: viewModel)

                case .profileSetup:
                    ProfileSetupView(viewModel: viewModel)

                case .authenticated:
                    authenticatedPlaceholder
                }
            }
            .animation(.easeInOut(duration: 0.3), value: viewModel.state)
        }
    }

    // MARK: - Authenticated Placeholder

    private var authenticatedPlaceholder: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.green)

            Text("Welcome!")
                .font(.system(size: 28, weight: .bold))

            Text("You are now signed in.")
                .font(.system(size: 17))
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    AuthenticationModule(authService: MockAuthService())
}
