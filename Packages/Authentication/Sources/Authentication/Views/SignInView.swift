import SwiftUI
import DesignSystem

/// Sign-in form with email and password fields.
struct SignInView: View {

    // MARK: - Properties

    @Bindable var viewModel: AuthViewModel

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                // Header
                VStack(spacing: AppSpacing.xs) {
                    Text("Welcome Back")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(AppColors.deepNavy)

                    Text("Sign in to continue to AgentAssist")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(AppColors.softGray)
                }
                .padding(.top, AppSpacing.xl)

                // Form
                VStack(spacing: AppSpacing.md) {
                    AATextField(
                        label: "Email",
                        text: $viewModel.email,
                        placeholder: "you@example.com"
                    )

                    AATextField(
                        label: "Password",
                        text: $viewModel.password,
                        placeholder: "Enter your password",
                        isSecure: true
                    )
                }

                // Error message
                if let error = viewModel.errorMessage {
                    HStack(spacing: AppSpacing.xs) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 14))
                        Text(error)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundStyle(AppColors.errorRed)
                    .padding(AppSpacing.sm)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppColors.errorRed.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small))
                }

                // Sign in button
                PillButton(
                    title: "Sign In",
                    style: .primary,
                    isLoading: viewModel.isLoading
                ) {
                    viewModel.signIn()
                }

                // Sign up link
                HStack(spacing: AppSpacing.xxs) {
                    Text("Don't have an account?")
                        .font(.system(size: 15))
                        .foregroundStyle(AppColors.softGray)

                    Button {
                        viewModel.goToSignUp()
                    } label: {
                        Text("Sign Up")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(AppColors.warmCoral)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, AppSpacing.xs)
            }
            .padding(.horizontal, AppSpacing.lg)
        }
        .background(AppColors.freshWhite)
        .navigationBarBackButtonHidden()
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SignInView(viewModel: AuthViewModel(authService: MockAuthService()))
    }
}
