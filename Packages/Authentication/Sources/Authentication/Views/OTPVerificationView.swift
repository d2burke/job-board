import SwiftUI
import DesignSystem

/// OTP verification screen with a 6-digit code input and resend capability.
struct OTPVerificationView: View {

    // MARK: - Properties

    @Bindable var viewModel: AuthViewModel
    @State private var resendCountdown: Int = 0
    @State private var resendTimer: Timer?

    // MARK: - Body

    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()

            // Icon
            ZStack {
                Circle()
                    .fill(AppColors.warmCoral.opacity(0.1))
                    .frame(width: 80, height: 80)

                Image(systemName: "envelope.badge.shield.half.filled")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundStyle(AppColors.warmCoral)
            }

            // Header
            VStack(spacing: AppSpacing.xs) {
                Text("Enter Verification Code")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(AppColors.deepNavy)

                Text("We sent a 6-digit code to\n\(viewModel.email)")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(AppColors.softGray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }

            // OTP input
            TextField("", text: $viewModel.otp)
                .keyboardType(.numberPad)
                .font(.system(size: 32, weight: .bold, design: .monospaced))
                .foregroundStyle(AppColors.deepNavy)
                .multilineTextAlignment(.center)
                .tracking(12)
                .padding(.horizontal, AppSpacing.xxl)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small)
                        .strokeBorder(
                            viewModel.otp.count == 6 ? AppColors.successGreen : AppColors.lightGray,
                            lineWidth: 1.5
                        )
                        .padding(.horizontal, AppSpacing.lg)
                )
                .onChange(of: viewModel.otp) { _, newValue in
                    // Limit to 6 digits
                    if newValue.count > 6 {
                        viewModel.otp = String(newValue.prefix(6))
                    }
                    // Filter non-numeric characters
                    viewModel.otp = newValue.filter { $0.isNumber }
                }

            // Error message
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(AppColors.errorRed)
            }

            // Verify button
            PillButton(
                title: "Verify",
                style: .primary,
                isLoading: viewModel.isLoading
            ) {
                viewModel.verifyOTP()
            }
            .padding(.horizontal, AppSpacing.lg)

            // Resend code
            if resendCountdown > 0 {
                Text("Resend code in \(resendCountdown)s")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppColors.softGray)
            } else {
                Button {
                    startResendCountdown()
                } label: {
                    Text("Resend Code")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(AppColors.warmCoral)
                }
                .buttonStyle(.plain)
            }

            Spacer()
            Spacer()
        }
        .background(AppColors.freshWhite)
        .navigationBarBackButtonHidden()
        .onAppear {
            startResendCountdown()
        }
        .onDisappear {
            resendTimer?.invalidate()
        }
    }

    // MARK: - Timer

    private func startResendCountdown() {
        resendCountdown = 30
        resendTimer?.invalidate()
        resendTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if resendCountdown > 0 {
                resendCountdown -= 1
            } else {
                timer.invalidate()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        OTPVerificationView(
            viewModel: {
                let vm = AuthViewModel(authService: MockAuthService())
                vm.email = "alex@example.com"
                return vm
            }()
        )
    }
}
