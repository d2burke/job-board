import SwiftUI
import SharedModels
import Networking

/// The root entry point for the TaskMarketplace feature module.
///
/// Displays the task feed with search, filtering, and detail navigation.
public struct TaskMarketplaceModule: View {

    // MARK: - State

    @State private var listViewModel: TaskListViewModel
    private let taskService: TaskServiceProtocol
    private let currentUser: User

    // MARK: - Init

    public init(taskService: TaskServiceProtocol, currentUser: User) {
        self.taskService = taskService
        self.currentUser = currentUser
        _listViewModel = State(initialValue: TaskListViewModel(taskService: taskService))
    }

    // MARK: - Body

    public var body: some View {
        NavigationStack {
            TaskFeedView(
                viewModel: listViewModel,
                taskService: taskService,
                currentUser: currentUser
            )
        }
        .task {
            listViewModel.loadTasks()
        }
    }
}

// MARK: - Preview

#Preview {
    TaskMarketplaceModule(
        taskService: MockTaskService(),
        currentUser: MockUsers.currentUser
    )
}
