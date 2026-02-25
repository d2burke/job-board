import SwiftUI
import DesignSystem
import SharedModels

/// Third step: set compensation and estimated duration.
struct TaskPricingView: View {

    // MARK: - Properties

    @Bindable var viewModel: PostTaskViewModel

    private let durationOptions = [
        "30 minutes",
        "1 hour",
        "1.5 hours",
        "2 hours",
        "3 hours",
        "4 hours",
        "Half day",
        "Full day"
    ]

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    // Header
                    VStack(spacing: AppSpacing.xs) {
                        Text("Set Your Price")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(AppColors.deepNavy)

                        Text("Choose fair compensation to attract quality agents")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(AppColors.softGray)
                    }

                    // Compensation input
                    VStack(spacing: AppSpacing.sm) {
                        Text("Compensation")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(AppColors.deepNavy)

                        HStack(alignment: .center, spacing: AppSpacing.xxs) {
                            Text("$")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(AppColors.warmCoral)

                            TextField("0", text: $viewModel.compensation)
                                .keyboardType(.numberPad)
                                .font(.system(size: 48, weight: .bold))
                                .foregroundStyle(AppColors.deepNavy)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: 180)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.lg)
                        .background(AppColors.warmCoral.opacity(0.04))
                        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.medium))
                        .overlay {
                            RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.medium)
                                .strokeBorder(AppColors.warmCoral.opacity(0.2), lineWidth: 1)
                        }
                    }

                    // Duration picker
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Estimated Duration")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(AppColors.deepNavy)

                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: AppSpacing.xs),
                                GridItem(.flexible(), spacing: AppSpacing.xs)
                            ],
                            spacing: AppSpacing.xs
                        ) {
                            ForEach(durationOptions, id: \.self) { duration in
                                durationChip(duration)
                            }
                        }
                    }

                    // Summary card
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Summary")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(AppColors.deepNavy)

                        VStack(spacing: AppSpacing.sm) {
                            summaryRow(
                                icon: viewModel.selectedCategory?.iconName ?? "questionmark.circle",
                                label: "Category",
                                value: viewModel.selectedCategory?.displayName ?? "Not selected"
                            )

                            Divider()

                            summaryRow(
                                icon: "doc.text",
                                label: "Title",
                                value: viewModel.title.isEmpty ? "Not entered" : viewModel.title
                            )

                            Divider()

                            summaryRow(
                                icon: "calendar",
                                label: "Date",
                                value: Self.dateFormatter.string(from: viewModel.scheduledDate)
                            )

                            Divider()

                            summaryRow(
                                icon: "dollarsign.circle",
                                label: "Compensation",
                                value: viewModel.formattedCompensation
                            )
                        }
                        .padding(AppSpacing.md)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.medium))
                        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
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
                PillButton(title: "Review Task", style: .primary) {
                    viewModel.nextStep()
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)
            }
            .background(.white)
        }
    }

    // MARK: - Duration Chip

    private func durationChip(_ duration: String) -> some View {
        let isSelected = viewModel.estimatedDuration == duration

        return Button {
            viewModel.estimatedDuration = duration
        } label: {
            Text(duration)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(isSelected ? .white : AppColors.deepNavy)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(isSelected ? AppColors.deepNavy : AppColors.lightGray.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Summary Row

    private func summaryRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(AppColors.warmCoral)
                .frame(width: 20)

            Text(label)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(AppColors.softGray)

            Spacer()

            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppColors.deepNavy)
                .lineLimit(1)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        TaskPricingView(
            viewModel: {
                let vm = PostTaskViewModel(
                    taskService: PreviewMockTaskService(),
                    currentUser: MockUsers.currentUser
                )
                vm.selectedCategory = .openHouse
                vm.title = "Open House Coverage - 3BR Ranch"
                return vm
            }()
        )
    }
}
