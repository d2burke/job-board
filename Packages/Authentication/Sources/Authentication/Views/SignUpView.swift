import SwiftUI
import DesignSystem

/// Account creation form with name, email, and password fields.
struct SignUpView: View {

    // MARK: - Properties

    @Bindable var viewModel: AuthViewModel

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                // Header
                VStack(spacing: AppSpacing.xs) {
                    Text("Create Account")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(AppColors.deepNavy)

                    Text("Join the AgentAssist marketplace")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(AppColors.softGray)
                }
                .padding(.top, AppSpacing.xl)

                // Form
                VStack(spacing: AppSpacing.md) {
                    HStack(spacing: AppSpacing.sm) {
                        AATextField(
                            label: "First Name",
                            text: $viewModel.firstName,
                            placeholder: "John"
                        )

                        AATextField(
                            label: "Last Name",
                            text: $viewModel.lastName,
                            placeholder: "Doe"
                        )
                    }

                    AATextField(
                        label: "Email",
                        text: $viewModel.email,
                        placeholder: "you@example.com"
                    )

                    AATextField(
                        label: "Password",
                        text: $viewModel.password,
                        placeholder: "Create a password",
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

                // Create account button
                PillButton(
                    title: "Create Account",
                    style: .primary,
                    isLoading: viewModel.isLoading
                ) {
                    viewModel.signUp()
                }

                // Sign in link
                HStack(spacing: AppSpacing.xxs) {
                    Text("Already have an account?")
                        .font(.system(size: 15))
                        .foregroundStyle(AppColors.softGray)

                    Button {
                        viewModel.goToSignIn()
                    } label: {
                        Text("Sign In")
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
        SignUpView(viewModel: AuthViewModel(authService: MockAuthService()))
    }
}
