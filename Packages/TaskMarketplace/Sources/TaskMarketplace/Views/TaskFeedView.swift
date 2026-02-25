import SwiftUI
import DesignSystem
import SharedModels
import Networking

/// Main task feed screen with search, list/map toggle, and filtering.
struct TaskFeedView: View {

    // MARK: - Properties

    @Bindable var viewModel: TaskListViewModel
    let taskService: TaskServiceProtocol
    let currentUser: User

    @State private var showFilterSheet = false

    // MARK: - Formatters

    private static let relativeDateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter
    }()

    private static let scheduleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d 'at' h:mm a"
        return formatter
    }()

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            searchBar

            // Segmented toggle
            segmentedToggle

            // Content
            if viewModel.isLoading {
                LoadingView(message: "Finding tasks near you...")
            } else if viewModel.filteredTasks.isEmpty {
                EmptyStateView(
                    icon: "magnifyingglass",
                    title: "No Tasks Found",
                    message: "Try adjusting your filters or check back later for new tasks in your area.",
                    buttonTitle: "Reset Filters"
                ) {
                    viewModel.resetFilters()
                }
            } else if viewModel.showMapView {
                TaskMapView(
                    tasks: viewModel.filteredTasks,
                    taskService: taskService,
                    currentUser: currentUser
                )
            } else {
                taskListView
            }
        }
        .background(AppColors.freshWhite)
        .navigationTitle("Tasks")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showFilterSheet = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.system(size: 18))
                        .foregroundStyle(
                            viewModel.selectedCategories.isEmpty
                                ? AppColors.deepNavy
                                : AppColors.warmCoral
                        )
                }
            }
        }
        .sheet(isPresented: $showFilterSheet) {
            TaskFilterSheet(viewModel: viewModel)
                .presentationDetents([.medium, .large])
        }
        .refreshable {
            viewModel.loadTasks()
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundStyle(AppColors.softGray)

            TextField("Search tasks...", text: $viewModel.searchText)
                .font(.system(size: 16))
                .foregroundStyle(AppColors.deepNavy)

            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(AppColors.softGray)
                }
            }
        }
        .padding(.horizontal, AppSpacing.sm)
        .frame(height: 44)
        .background(AppColors.lightGray.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small))
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.xs)
    }

    // MARK: - Segmented Toggle

    private var segmentedToggle: some View {
        HStack(spacing: 0) {
            segmentButton(title: "List", icon: "list.bullet", isSelected: !viewModel.showMapView) {
                viewModel.showMapView = false
            }
            segmentButton(title: "Map", icon: "map", isSelected: viewModel.showMapView) {
                viewModel.showMapView = true
            }
        }
        .background(AppColors.lightGray.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small))
        .padding(.horizontal, AppSpacing.md)
        .padding(.bottom, AppSpacing.xs)
    }

    private func segmentButton(title: String, icon: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.xxs) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .medium))
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundStyle(isSelected ? .white : AppColors.deepNavy)
            .frame(maxWidth: .infinity)
            .frame(height: 36)
            .background(isSelected ? AppColors.deepNavy : .clear)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small - 2))
            .padding(2)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Task List

    private var taskListView: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.sm) {
                ForEach(viewModel.filteredTasks) { task in
                    NavigationLink {
                        TaskDetailView(
                            taskId: task.id,
                            taskService: taskService,
                            currentUser: currentUser,
                            preloadedTask: task
                        )
                    } label: {
                        TaskCard(
                            title: task.title,
                            category: task.category.displayName,
                            categoryColor: colorForCategory(task.category),
                            compensation: task.formattedCompensation,
                            location: "\(task.city), \(task.state)",
                            timeAgo: Self.relativeDateFormatter.localizedString(
                                for: task.createdAt,
                                relativeTo: Date()
                            ),
                            scheduledDate: task.scheduledFor.map {
                                Self.scheduleDateFormatter.string(from: $0)
                            },
                            avatarURL: task.postedBy.avatarURL
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.xs)
        }
    }
}

// MARK: - Category Color Helper

func colorForCategory(_ category: TaskCategory) -> Color {
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

// MARK: - Preview

#Preview {
    NavigationStack {
        TaskFeedView(
            viewModel: {
                let vm = TaskListViewModel(taskService: MockTaskService())
                vm.tasks = MockTaskService.sampleTasks
                vm.filteredTasks = MockTaskService.sampleTasks
                return vm
            }(),
            taskService: MockTaskService(),
            currentUser: MockUsers.currentUser
        )
    }
}
