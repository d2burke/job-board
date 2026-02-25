import SwiftUI
import DesignSystem
import SharedModels

/// Second step: enter task title, description, location, schedule, and requirements.
struct TaskDetailsForm: View {

    // MARK: - Properties

    @Bindable var viewModel: PostTaskViewModel

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    // Header
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text("Task Details")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(AppColors.deepNavy)

                        Text("Provide the information agents need to complete this task")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(AppColors.softGray)
                    }

                    // Title
                    AATextField(
                        label: "Title",
                        text: $viewModel.title,
                        placeholder: "e.g., Open House Coverage - 3BR Ranch"
                    )

                    // Description
                    VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                        Text("Description")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(AppColors.deepNavy)

                        TextEditor(text: $viewModel.description)
                            .font(.system(size: 17))
                            .foregroundStyle(AppColors.deepNavy)
                            .frame(minHeight: 100)
                            .padding(AppSpacing.sm)
                            .background(AppColors.freshWhite)
                            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small))
                            .overlay {
                                RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small)
                                    .strokeBorder(AppColors.lightGray, lineWidth: 1)
                            }
                            .overlay(alignment: .topLeading) {
                                if viewModel.description.isEmpty {
                                    Text("Describe what the agent needs to do...")
                                        .font(.system(size: 17))
                                        .foregroundStyle(AppColors.softGray.opacity(0.6))
                                        .padding(.horizontal, AppSpacing.sm + 5)
                                        .padding(.vertical, AppSpacing.sm + 8)
                                        .allowsHitTesting(false)
                                }
                            }
                    }

                    // Location
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Location")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(AppColors.deepNavy)

                        AATextField(
                            label: "Street Address",
                            text: $viewModel.address,
                            placeholder: "123 Main St"
                        )

                        HStack(spacing: AppSpacing.sm) {
                            AATextField(
                                label: "City",
                                text: $viewModel.city,
                                placeholder: "Austin"
                            )

                            AATextField(
                                label: "State",
                                text: $viewModel.state,
                                placeholder: "TX"
                            )
                            .frame(width: 80)

                            AATextField(
                                label: "Zip",
                                text: $viewModel.zipCode,
                                placeholder: "78701"
                            )
                            .frame(width: 90)
                        }
                    }

                    // Schedule
                    VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                        Text("Scheduled Date & Time")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(AppColors.deepNavy)

                        DatePicker(
                            "",
                            selection: $viewModel.scheduledDate,
                            in: Date()...,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .datePickerStyle(.graphical)
                        .tint(AppColors.warmCoral)
                    }

                    // Requirements
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Requirements")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(AppColors.deepNavy)

                        // Added requirements
                        if !viewModel.requirements.isEmpty {
                            VStack(spacing: AppSpacing.xs) {
                                ForEach(Array(viewModel.requirements.enumerated()), id: \.offset) { index, requirement in
                                    HStack(spacing: AppSpacing.sm) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 14))
                                            .foregroundStyle(AppColors.successGreen)

                                        Text(requirement)
                                            .font(.system(size: 15))
                                            .foregroundStyle(AppColors.deepNavy)

                                        Spacer()

                                        Button {
                                            viewModel.removeRequirement(at: index)
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.system(size: 16))
                                                .foregroundStyle(AppColors.softGray)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .padding(AppSpacing.sm)
                                    .background(AppColors.successGreen.opacity(0.06))
                                    .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small))
                                }
                            }
                        }

                        // Add requirement
                        HStack(spacing: AppSpacing.xs) {
                            TextField("Add a requirement...", text: $viewModel.newRequirement)
                                .font(.system(size: 15))
                                .foregroundStyle(AppColors.deepNavy)
                                .padding(.horizontal, AppSpacing.sm)
                                .frame(height: 44)
                                .background(AppColors.freshWhite)
                                .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small))
                                .overlay {
                                    RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small)
                                        .strokeBorder(AppColors.lightGray, lineWidth: 1)
                                }
                                .onSubmit {
                                    viewModel.addRequirement()
                                }

                            Button {
                                viewModel.addRequirement()
                            } label: {
                                Text("Add")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, AppSpacing.md)
                                    .frame(height: 44)
                                    .background(
                                        viewModel.newRequirement.isEmpty
                                            ? AppColors.softGray
                                            : AppColors.deepNavy
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small))
                            }
                            .buttonStyle(.plain)
                            .disabled(viewModel.newRequirement.isEmpty)
                        }
                    }

                    // Error
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
                }
                .padding(AppSpacing.md)
                .padding(.bottom, AppSpacing.xxl)
            }

            // Next button
            VStack(spacing: 0) {
                Divider()
                PillButton(title: "Next", style: .primary) {
                    viewModel.nextStep()
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)
            }
            .background(.white)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        TaskDetailsForm(
            viewModel: {
                let vm = PostTaskViewModel(
                    taskService: PreviewMockTaskService(),
                    currentUser: MockUsers.currentUser
                )
                vm.selectedCategory = .openHouse
                return vm
            }()
        )
    }
}
