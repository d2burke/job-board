import SwiftUI
import DesignSystem
import SharedModels

/// First step: select a task category from a grid of options.
struct CategorySelectView: View {

    // MARK: - Properties

    @Bindable var viewModel: PostTaskViewModel

    private let columns = [
        GridItem(.flexible(), spacing: AppSpacing.sm),
        GridItem(.flexible(), spacing: AppSpacing.sm)
    ]

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    // Header
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text("What type of task?")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(AppColors.deepNavy)

                        Text("Select the category that best describes your task")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(AppColors.softGray)
                    }

                    // Category grid
                    LazyVGrid(columns: columns, spacing: AppSpacing.sm) {
                        ForEach(TaskCategory.allCases) { category in
                            categoryCard(for: category)
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
                    }
                }
                .padding(AppSpacing.md)
            }

            // Next button
            VStack(spacing: 0) {
                Divider()
                PillButton(
                    title: "Next",
                    style: viewModel.selectedCategory != nil ? .primary : .outline
                ) {
                    viewModel.nextStep()
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)
            }
            .background(.white)
        }
    }

    // MARK: - Category Card

    private func categoryCard(for category: TaskCategory) -> some View {
        let isSelected = viewModel.selectedCategory == category

        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.selectedCategory = category
                viewModel.errorMessage = nil
            }
        } label: {
            VStack(spacing: AppSpacing.sm) {
                ZStack {
                    Circle()
                        .fill(isSelected ? AppColors.warmCoral.opacity(0.15) : AppColors.lightGray.opacity(0.6))
                        .frame(width: 52, height: 52)

                    Image(systemName: category.iconName)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(isSelected ? AppColors.warmCoral : AppColors.deepNavy.opacity(0.6))
                }

                Text(category.displayName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(isSelected ? AppColors.deepNavy : AppColors.deepNavy.opacity(0.7))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(isSelected ? AppColors.warmCoral.opacity(0.06) : .white)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.medium))
            .overlay {
                RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.medium)
                    .strokeBorder(
                        isSelected ? AppColors.warmCoral : AppColors.lightGray,
                        lineWidth: isSelected ? 2 : 1
                    )
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        CategorySelectView(
            viewModel: PostTaskViewModel(
                taskService: PreviewMockTaskService(),
                currentUser: MockUsers.currentUser
            )
        )
    }
}

/// Minimal mock for previews within this module.
struct PreviewMockTaskService: TaskServiceProtocol {
    func fetchNearbyTasks(latitude: Double, longitude: Double, radiusMiles: Double) async throws -> [AgentTask] { [] }
    func fetchTaskDetail(id: String) async throws -> AgentTask {
        throw NSError(domain: "", code: 404)
    }
    func createTask(_ task: AgentTask) async throws -> AgentTask { task }
    func applyForTask(taskId: String, message: String?) async throws {}
    func updateTaskStatus(taskId: String, status: TaskStatus) async throws {}
    func fetchMyPostedTasks() async throws -> [AgentTask] { [] }
    func fetchMyAssignedTasks() async throws -> [AgentTask] { [] }
}
