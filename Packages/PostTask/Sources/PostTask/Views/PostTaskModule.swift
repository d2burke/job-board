import SwiftUI
import DesignSystem
import SharedModels
import Networking

/// The root entry point for the PostTask feature module.
///
/// Manages a multi-step task creation wizard with category selection,
/// details form, pricing, review, and submission confirmation.
public struct PostTaskModule: View {

    // MARK: - State

    @State private var viewModel: PostTaskViewModel

    // MARK: - Init

    public init(taskService: TaskServiceProtocol, currentUser: User) {
        _viewModel = State(initialValue: PostTaskViewModel(taskService: taskService, currentUser: currentUser))
    }

    // MARK: - Body

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress bar (hidden on submitted)
                if viewModel.currentStep != .submitted {
                    progressBar
                }

                // Step content
                Group {
                    switch viewModel.currentStep {
                    case .category:
                        CategorySelectView(viewModel: viewModel)
                    case .details:
                        TaskDetailsForm(viewModel: viewModel)
                    case .pricing:
                        TaskPricingView(viewModel: viewModel)
                    case .review:
                        TaskReviewView(viewModel: viewModel)
                    case .submitted:
                        submittedView
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: viewModel.currentStep)
            }
            .background(AppColors.freshWhite)
            .navigationTitle(viewModel.currentStep == .submitted ? "Success" : "Post a Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if viewModel.currentStep != .submitted && viewModel.currentStep != .category {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            viewModel.previousStep()
                        } label: {
                            HStack(spacing: AppSpacing.xxs) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Back")
                                    .font(.system(size: 17))
                            }
                            .foregroundStyle(AppColors.deepNavy)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Progress Bar

    private var progressBar: some View {
        VStack(spacing: AppSpacing.xs) {
            // Step indicators
            HStack(spacing: AppSpacing.xxs) {
                ForEach(0..<PostTaskStep.totalEditableSteps, id: \.self) { index in
                    let step = PostTaskStep(rawValue: index) ?? .category
                    RoundedRectangle(cornerRadius: 2)
                        .fill(
                            index <= viewModel.currentStep.rawValue
                                ? AppColors.warmCoral
                                : AppColors.lightGray
                        )
                        .frame(height: 4)
                }
            }

            // Step label
            Text("Step \(viewModel.currentStep.stepNumber) of \(PostTaskStep.totalEditableSteps): \(viewModel.currentStep.title)")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(AppColors.softGray)
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
    }

    // MARK: - Submitted View

    private var submittedView: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()

            ZStack {
                Circle()
                    .fill(AppColors.successGreen.opacity(0.1))
                    .frame(width: 120, height: 120)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64, weight: .medium))
                    .foregroundStyle(AppColors.successGreen)
            }

            Text("Task Posted!")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(AppColors.deepNavy)

            Text("Your task has been published to the marketplace.\nAgents can now discover and apply for it.")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(AppColors.softGray)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, AppSpacing.xl)

            // Summary card
            VStack(spacing: AppSpacing.sm) {
                if let category = viewModel.selectedCategory {
                    HStack {
                        Image(systemName: category.iconName)
                            .font(.system(size: 14))
                        Text(category.displayName)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundStyle(AppColors.warmCoral)
                }

                Text(viewModel.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(AppColors.deepNavy)

                Text(viewModel.formattedCompensation)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(AppColors.warmCoral)
            }
            .padding(AppSpacing.lg)
            .frame(maxWidth: .infinity)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.medium))
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
            .padding(.horizontal, AppSpacing.lg)

            Spacer()
            Spacer()
        }
    }
}

// MARK: - Mock Service for Preview

private struct PreviewTaskService: TaskServiceProtocol {
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

// MARK: - Preview

#Preview {
    PostTaskModule(
        taskService: PreviewTaskService(),
        currentUser: MockUsers.currentUser
    )
}
