import SwiftUI
import DesignSystem
import SharedModels

/// Bottom sheet providing category, sort, and distance filters.
struct TaskFilterSheet: View {

    // MARK: - Properties

    @Bindable var viewModel: TaskListViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {

                    // Categories section
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Categories")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(AppColors.deepNavy)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppSpacing.xs) {
                                ForEach(TaskCategory.allCases) { category in
                                    categoryToggle(for: category)
                                }
                            }
                        }
                    }

                    Divider()

                    // Sort by section
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Sort By")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(AppColors.deepNavy)

                        Picker("Sort By", selection: $viewModel.sortOrder) {
                            ForEach(TaskSortOrder.allCases) { order in
                                Text(order.rawValue).tag(order)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    Divider()

                    // Distance section
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        HStack {
                            Text("Distance")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(AppColors.deepNavy)

                            Spacer()

                            Text("\(Int(viewModel.maxDistanceMiles)) miles")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(AppColors.warmCoral)
                        }

                        Slider(
                            value: $viewModel.maxDistanceMiles,
                            in: 1...50,
                            step: 1
                        )
                        .tint(AppColors.warmCoral)

                        HStack {
                            Text("1 mi")
                                .font(.system(size: 13))
                                .foregroundStyle(AppColors.softGray)
                            Spacer()
                            Text("50 mi")
                                .font(.system(size: 13))
                                .foregroundStyle(AppColors.softGray)
                        }
                    }

                    Divider()

                    // Active filter count
                    if !viewModel.selectedCategories.isEmpty {
                        HStack(spacing: AppSpacing.xs) {
                            Image(systemName: "line.3.horizontal.decrease")
                                .font(.system(size: 14))
                            Text("\(viewModel.selectedCategories.count) category filter\(viewModel.selectedCategories.count == 1 ? "" : "s") active")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundStyle(AppColors.warmCoral)
                    }

                    // Buttons
                    VStack(spacing: AppSpacing.sm) {
                        PillButton(title: "Apply Filters", style: .primary) {
                            dismiss()
                        }

                        Button {
                            viewModel.resetFilters()
                        } label: {
                            Text("Reset")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(AppColors.softGray)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top, AppSpacing.xs)
                }
                .padding(AppSpacing.lg)
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(AppColors.deepNavy)
                }
            }
        }
    }

    // MARK: - Category Toggle

    private func categoryToggle(for category: TaskCategory) -> some View {
        let isSelected = viewModel.selectedCategories.contains(category)

        return Button {
            viewModel.toggleCategory(category)
        } label: {
            HStack(spacing: AppSpacing.xxs) {
                Image(systemName: category.iconName)
                    .font(.system(size: 12))

                Text(category.displayName)
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundStyle(isSelected ? .white : AppColors.deepNavy)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, AppSpacing.xs)
            .background(isSelected ? AppColors.deepNavy : AppColors.lightGray.opacity(0.6))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    TaskFilterSheet(viewModel: TaskListViewModel(taskService: MockTaskService()))
        .presentationDetents([.medium, .large])
}
