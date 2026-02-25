import SwiftUI
import DesignSystem
import SharedModels

/// Profile setup form for new users to enter license info and select specialties.
struct ProfileSetupView: View {

    // MARK: - Properties

    @Bindable var viewModel: AuthViewModel

    private let columns = [
        GridItem(.flexible(), spacing: AppSpacing.sm),
        GridItem(.flexible(), spacing: AppSpacing.sm)
    ]

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                // Header
                VStack(spacing: AppSpacing.xs) {
                    Text("Complete Your Profile")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(AppColors.deepNavy)

                    Text("Help us personalize your experience")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(AppColors.softGray)
                }
                .padding(.top, AppSpacing.lg)

                // License and Brokerage
                VStack(spacing: AppSpacing.md) {
                    AATextField(
                        label: "License Number",
                        text: $viewModel.licenseNumber,
                        placeholder: "e.g., TX-12345678"
                    )

                    AATextField(
                        label: "Brokerage",
                        text: $viewModel.brokerage,
                        placeholder: "e.g., Compass Real Estate"
                    )
                }

                // Specialties
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("Specialties")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(AppColors.deepNavy)

                    Text("Select the task types you specialize in")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(AppColors.softGray)

                    LazyVGrid(columns: columns, spacing: AppSpacing.sm) {
                        ForEach(TaskCategory.allCases) { category in
                            specialtyChip(for: category)
                        }
                    }
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

                // Complete setup
                PillButton(
                    title: "Complete Setup",
                    style: .primary,
                    isLoading: viewModel.isLoading
                ) {
                    viewModel.completeProfileSetup()
                }

                // Skip
                Button {
                    viewModel.skipProfileSetup()
                } label: {
                    Text("Skip for now")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(AppColors.softGray)
                }
                .buttonStyle(.plain)
                .padding(.bottom, AppSpacing.xl)
            }
            .padding(.horizontal, AppSpacing.lg)
        }
        .background(AppColors.freshWhite)
        .navigationBarBackButtonHidden()
    }

    // MARK: - Specialty Chip

    private func specialtyChip(for category: TaskCategory) -> some View {
        let isSelected = viewModel.selectedSpecialties.contains(category)

        return Button {
            viewModel.toggleSpecialty(category)
        } label: {
            HStack(spacing: AppSpacing.xs) {
                Image(systemName: category.iconName)
                    .font(.system(size: 14))

                Text(category.displayName)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(1)
            }
            .foregroundStyle(isSelected ? .white : AppColors.deepNavy)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, AppSpacing.sm)
            .frame(maxWidth: .infinity)
            .background(isSelected ? AppColors.deepNavy : AppColors.lightGray.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small))
            .overlay {
                if isSelected {
                    RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small)
                        .strokeBorder(AppColors.deepNavy, lineWidth: 1.5)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ProfileSetupView(viewModel: AuthViewModel(authService: MockAuthService()))
    }
}
