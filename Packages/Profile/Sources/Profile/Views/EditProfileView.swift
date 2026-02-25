import SwiftUI
import SharedModels
import DesignSystem

/// A sheet for editing the current user's profile information.
public struct EditProfileView: View {

    // MARK: - Properties

    @Bindable var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Init

    public init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    personalInfoSection
                    professionalSection
                    specialtiesSection
                    saveButton
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.top, AppSpacing.md)
                .padding(.bottom, AppSpacing.xl)
            }
            .background(AppColors.freshWhite)
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        viewModel.populateEditFields()
                        dismiss()
                    }
                    .foregroundStyle(AppColors.softGray)
                }
            }
        }
    }

    // MARK: - Personal Info

    private var personalInfoSection: some View {
        VStack(spacing: AppSpacing.md) {
            sectionHeader("Personal Information")

            AATextField(
                label: "First Name",
                text: $viewModel.editFirstName,
                placeholder: "Enter first name"
            )

            AATextField(
                label: "Last Name",
                text: $viewModel.editLastName,
                placeholder: "Enter last name"
            )

            AATextField(
                label: "Phone",
                text: $viewModel.editPhone,
                placeholder: "(555) 555-5555"
            )

            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text("Bio")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppColors.deepNavy)

                TextEditor(text: $viewModel.editBio)
                    .font(.system(size: 16))
                    .foregroundStyle(AppColors.deepNavy)
                    .frame(minHeight: 100)
                    .padding(AppSpacing.xs)
                    .background(AppColors.freshWhite)
                    .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small))
                    .overlay {
                        RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small)
                            .strokeBorder(AppColors.lightGray, lineWidth: 1)
                    }
                    .scrollContentBackground(.hidden)
            }
        }
    }

    // MARK: - Professional Info

    private var professionalSection: some View {
        VStack(spacing: AppSpacing.md) {
            sectionHeader("Professional Details")

            AATextField(
                label: "License Number",
                text: $viewModel.editLicenseNumber,
                placeholder: "e.g. TX-12345678"
            )

            AATextField(
                label: "Brokerage",
                text: $viewModel.editBrokerage,
                placeholder: "Enter brokerage name"
            )
        }
    }

    // MARK: - Specialties

    private var specialtiesSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            sectionHeader("Specialties")

            Text("Select your areas of expertise")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(AppColors.softGray)

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: AppSpacing.sm
            ) {
                ForEach(TaskCategory.allCases) { category in
                    specialtyToggle(category)
                }
            }
        }
    }

    private func specialtyToggle(_ category: TaskCategory) -> some View {
        let isSelected = viewModel.editSpecialties.contains(category)

        return Button {
            viewModel.toggleSpecialty(category)
        } label: {
            HStack(spacing: AppSpacing.xs) {
                Image(systemName: category.iconName)
                    .font(.system(size: 14))

                Text(category.displayName)
                    .font(.system(size: 13, weight: .semibold))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.sm)
            .padding(.horizontal, AppSpacing.xs)
            .foregroundStyle(isSelected ? .white : AppColors.deepNavy)
            .background(isSelected ? AppColors.warmCoral : AppColors.lightGray)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Save

    private var saveButton: some View {
        PillButton(
            title: "Save Changes",
            style: .primary,
            isLoading: viewModel.isLoading
        ) {
            viewModel.saveProfile()
        }
        .padding(.top, AppSpacing.sm)
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(AppColors.deepNavy)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Preview

#Preview {
    EditProfileView(
        viewModel: ProfileViewModel(
            profileService: MockProfileService(),
            paymentService: MockPaymentService(),
            user: SharedModels.MockUsers.currentUser
        )
    )
}
