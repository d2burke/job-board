import SwiftUI
import DesignSystem
import SharedModels
import Networking

/// Detailed view for a single task with full info and apply action.
struct TaskDetailView: View {

    // MARK: - Properties

    @State private var viewModel: TaskDetailViewModel
    private let currentUser: User

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        return f
    }()

    // MARK: - Init

    init(
        taskId: String,
        taskService: TaskServiceProtocol,
        currentUser: User,
        preloadedTask: AgentTask? = nil
    ) {
        let vm = TaskDetailViewModel(taskService: taskService)
        if let task = preloadedTask {
            vm.task = task
        }
        _viewModel = State(initialValue: vm)
        self.currentUser = currentUser
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .bottom) {
            if viewModel.isLoading && viewModel.task == nil {
                LoadingView(message: "Loading task details...")
            } else if let task = viewModel.task {
                taskContent(task)
            }
        }
        .background(AppColors.freshWhite)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showApplicationSheet) {
            applicationSheet
        }
    }

    // MARK: - Task Content

    private func taskContent(_ task: AgentTask) -> some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    // Category + Status
                    HStack(spacing: AppSpacing.sm) {
                        CategoryChip(
                            label: task.category.displayName,
                            color: colorForCategory(task.category)
                        )
                        StatusBadge(
                            status: task.status.displayName,
                            color: colorForStatus(task.status)
                        )
                        Spacer()
                    }

                    // Title
                    Text(task.title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(AppColors.deepNavy)

                    // Compensation
                    HStack(spacing: AppSpacing.xs) {
                        Text(task.formattedCompensation)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(AppColors.warmCoral)

                        Text("compensation")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(AppColors.softGray)
                    }

                    Divider()

                    // Posted by
                    HStack(spacing: AppSpacing.sm) {
                        AvatarView(
                            url: task.postedBy.avatarURL,
                            size: 48,
                            showBadge: task.postedBy.isVerified
                        )

                        VStack(alignment: .leading, spacing: AppSpacing.xxxs) {
                            Text("Posted by")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundStyle(AppColors.softGray)

                            Text(task.postedBy.fullName)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(AppColors.deepNavy)

                            HStack(spacing: AppSpacing.xxs) {
                                RatingView(rating: task.postedBy.rating, size: 14)
                                Text(String(format: "%.1f", task.postedBy.rating))
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(AppColors.deepNavy)
                                Text("(\(task.postedBy.reviewCount) reviews)")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundStyle(AppColors.softGray)
                            }
                        }

                        Spacer()
                    }
                    .padding(AppSpacing.md)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.medium))
                    .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)

                    // Description
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text("Description")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(AppColors.deepNavy)

                        Text(task.description)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(AppColors.deepNavy.opacity(0.8))
                            .lineSpacing(4)
                    }

                    // Requirements
                    if !task.requirements.isEmpty {
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text("Requirements")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(AppColors.deepNavy)

                            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                ForEach(task.requirements, id: \.self) { requirement in
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

                    // Details grid
                    VStack(spacing: AppSpacing.sm) {
                        detailRow(
                            icon: "mappin.and.ellipse",
                            label: "Location",
                            value: task.fullAddress
                        )

                        if let scheduledDate = task.scheduledFor {
                            detailRow(
                                icon: "calendar",
                                label: "Scheduled",
                                value: Self.dateFormatter.string(from: scheduledDate)
                            )
                        }

                        detailRow(
                            icon: "clock",
                            label: "Estimated Duration",
                            value: task.estimatedDuration
                        )
                    }
                    .padding(AppSpacing.md)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.medium))
                    .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)

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

                    // Bottom spacer for the sticky button
                    Spacer()
                        .frame(height: 80)
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.top, AppSpacing.md)
            }

            // Sticky apply button
            if task.status == .open {
                VStack(spacing: 0) {
                    Divider()
                    PillButton(title: "Apply for Task", style: .primary) {
                        viewModel.showApplicationSheet = true
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.md)
                }
                .background(.white)
            }
        }
    }

    // MARK: - Detail Row

    private func detailRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(AppColors.warmCoral)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: AppSpacing.xxxs) {
                Text(label)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(AppColors.softGray)

                Text(value)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppColors.deepNavy)
            }

            Spacer()
        }
    }

    // MARK: - Application Sheet

    private var applicationSheet: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.lg) {
                Text("Why are you a good fit for this task?")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(AppColors.deepNavy)
                    .frame(maxWidth: .infinity, alignment: .leading)

                TextEditor(text: $viewModel.applicationMessage)
                    .font(.system(size: 16))
                    .foregroundStyle(AppColors.deepNavy)
                    .frame(minHeight: 120)
                    .padding(AppSpacing.sm)
                    .background(AppColors.freshWhite)
                    .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small))
                    .overlay {
                        RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small)
                            .strokeBorder(AppColors.lightGray, lineWidth: 1)
                    }

                PillButton(
                    title: "Submit Application",
                    style: .primary,
                    isLoading: viewModel.isApplying
                ) {
                    viewModel.applyForTask()
                }

                Spacer()
            }
            .padding(AppSpacing.lg)
            .navigationTitle("Apply")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        viewModel.showApplicationSheet = false
                    }
                    .foregroundStyle(AppColors.softGray)
                }
            }
        }
        .presentationDetents([.medium])
    }

    // MARK: - Status Color

    private func colorForStatus(_ status: TaskStatus) -> Color {
        switch status {
        case .open: return AppColors.successGreen
        case .assigned: return .blue
        case .inProgress: return AppColors.warningAmber
        case .completed: return AppColors.deepNavy
        case .cancelled: return AppColors.errorRed
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        TaskDetailView(
            taskId: "task-001",
            taskService: MockTaskService(),
            currentUser: MockUsers.currentUser,
            preloadedTask: MockTaskService.sampleTasks[0]
        )
    }
}
