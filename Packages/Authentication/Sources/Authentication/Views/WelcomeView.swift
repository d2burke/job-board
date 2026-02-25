import SwiftUI
import DesignSystem

/// Splash screen shown on app launch.
///
/// Presents the app logo, tagline, and primary actions to get started
/// or sign in with an existing account.
struct WelcomeView: View {

    // MARK: - Properties

    @Bindable var viewModel: AuthViewModel

    // MARK: - Body

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [
                    AppColors.deepNavy,
                    AppColors.deepNavy.opacity(0.85),
                    AppColors.warmCoral.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: AppSpacing.xl) {
                Spacer()
                Spacer()

                // App icon
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.15))
                        .frame(width: 120, height: 120)

                    Image(systemName: "house.fill")
                        .font(.system(size: 52, weight: .medium))
                        .foregroundStyle(.white)
                }

                // App name
                VStack(spacing: AppSpacing.xs) {
                    Text("AgentAssist")
                        .font(.system(size: 38, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Your Real Estate Task Marketplace")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                }

                Spacer()

                // Actions
                VStack(spacing: AppSpacing.md) {
                    PillButton(title: "Get Started", style: .primary) {
                        viewModel.goToOnboarding()
                    }

                    Button {
                        viewModel.skipToSignIn()
                    } label: {
                        Text("I already have an account")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.xxl)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        WelcomeView(viewModel: AuthViewModel(authService: MockAuthService()))
    }
}
