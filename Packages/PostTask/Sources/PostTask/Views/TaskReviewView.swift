import SwiftUI
import DesignSystem
import SharedModels

/// Fourth step: review all entered info and submit the task.
struct TaskReviewView: View {

    // MARK: - Properties

    @Bindable var viewModel: PostTaskViewModel

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        return f
    }()

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    // Header
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text("Review Your Task")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(AppColors.deepNavy)

                        Text("Make sure everything looks good before posting")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(AppColors.softGray)
                    }

                    // Category and title
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        if let category = viewModel.selectedCategory {
                            CategoryChip(
                                label: category.displayName,
                                color: colorForCategory(category)
                            )
                        }

                        Text(viewModel.title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(AppColors.deepNavy)

                        Text(viewModel.formattedCompensation)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(AppColors.warmCoral)
                    }
                    .padding(AppSpacing.md)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.medium))
                    .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)

                    // Description
                    sectionCard(title: "Description") {
                        Text(viewModel.description)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(AppColors.deepNavy.opacity(0.8))
                            .lineSpacing(4)
                    }

                    // Location
                    sectionCard(title: "Location") {
                        HStack(spacing: AppSpacing.sm) {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 16))
                                .foregroundStyle(AppColors.warmCoral)

                            VStack(alignment: .leading, spacing: AppSpacing.xxxs) {
                                Text(viewModel.address)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(AppColors.deepNavy)

                                Text("\(viewModel.city), \(viewModel.state) \(viewModel.zipCode)")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(AppColors.softGray)
                            }
                        }
                    }

                    // Schedule and duration
                    sectionCard(title: "Schedule") {
                        VStack(spacing: AppSpacing.sm) {
                            HStack(spacing: AppSpacing.sm) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 14))
                                    .foregroundStyle(AppColors.warmCoral)
                                    .frame(width: 20)

                                Text(Self.dateFormatter.string(from: viewModel.scheduledDate))
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(AppColors.deepNavy)

                                Spacer()
                            }

                            HStack(spacing: AppSpacing.sm) {
                                Image(systemName: "clock")
                                    .font(.system(size: 14))
                                    .foregroundStyle(AppColors.warmCoral)
                                    .frame(width: 20)

                                Text(viewModel.estimatedDuration)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(AppColors.deepNavy)

                                Spacer()
                            }
                        }
                    }

                    // Requirements
                    if !viewModel.requirements.isEmpty {
                        sectionCard(title: "Requirements") {
                            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                ForEach(viewModel.requirements, id: \.self) { requirement in
                                    HStack(alignment: .top, spacing: AppSpacing.xs) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 14))
                                            .foregroundStyle(AppColors.successGreen)
                                            .padding(.top, 2)

                                        Text(requirement)
                                            .font(.system(size: 15, weight: .regular))
                                            .foregroundStyle(AppColors.deepNavy.opacity(0.8))
                                    }
                                }
                            }
                        }
                    }

                    // Edit button
                    Button {
                        viewModel.goToStep(.category)
                    } label: {
                        HStack(spacing: AppSpacing.xs) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 16))
                            Text("Edit Task Details")
                                .font(.system(size: 15, weight: .medium))
                        }
                        .foregroundStyle(AppColors.warmCoral)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                    }
                    .buttonStyle(.plain)

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

            // Post button
            VStack(spacing: 0) {
                Divider()
                PillButton(
                    title: "Post Task",
                    style: .primary,
                    isLoading: viewModel.isLoading
                ) {
                    viewModel.submitTask()
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)
            }
            .background(.white)
        }
    }

    // MARK: - Section Card

    private func sectionCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(AppColors.softGray)
                .textCase(.uppercase)
                .tracking(0.5)

            content()
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.medium))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    // MARK: - Category Color

    private func colorForCategory(_ category: TaskCategory) -> Color {
        switch category {
        case .openHouse: return .blue
        case .showing: return .indigo
        case .photography: return .purple
        case .inspection: return .orange
        case .staging: return .green
        case .signInstall: return .teal
        case .lockbox: return .brown
        case .flyerDelivery: return .pink
        case .research: return .cyan
        case .other: return .gray
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        TaskReviewView(
            viewModel: {
                let vm = PostTaskViewModel(
                    taskService: PreviewMockTaskService(),
                    currentUser: MockUsers.currentUser
                )
                vm.selectedCategory = .openHouse
                vm.title = "Open House Coverage - 3BR Ranch in Westlake"
                vm.description = "Looking for a licensed agent to host an open house for a beautiful 3-bedroom ranch home in the Westlake Hills area."
                vm.address = "2401 Westlake Dr"
                vm.city = "Austin"
                vm.state = "TX"
                vm.zipCode = "78746"
                vm.compensation = "150"
                vm.estimatedDuration = "3 hours"
                vm.requirements = [
                    "Active Texas real estate license",
                    "Professional attire required",
                    "Must arrive 30 minutes early"
                ]
                return vm
            }()
        )
    }
}
