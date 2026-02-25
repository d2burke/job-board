import Foundation
import Observation
import SharedModels
import Networking

// MARK: - TaskDetailViewModel

@Observable
public final class TaskDetailViewModel {

    // MARK: - State

    public var task: AgentTask?
    public var isLoading: Bool = false
    public var isApplying: Bool = false
    public var applicationMessage: String = ""
    public var showApplicationSheet: Bool = false
    public var errorMessage: String?

    // MARK: - Dependencies

    private let taskService: TaskServiceProtocol

    // MARK: - Init

    public init(taskService: TaskServiceProtocol) {
        self.taskService = taskService
    }

    // MARK: - Actions

    public func loadTask(id: String) {
        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            do {
                let fetched = try await taskService.fetchTaskDetail(id: id)
                task = fetched
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }

    public func applyForTask() {
        guard let task else { return }
        isApplying = true
        errorMessage = nil

        Task { @MainActor in
            do {
                try await taskService.applyForTask(
                    taskId: task.id,
                    message: applicationMessage.isEmpty ? nil : applicationMessage
                )
                isApplying = false
                showApplicationSheet = false
                applicationMessage = ""
            } catch {
                isApplying = false
                errorMessage = error.localizedDescription
            }
        }
    }

    public func updateStatus(_ status: TaskStatus) {
        guard let task else { return }
        isLoading = true

        Task { @MainActor in
            do {
                try await taskService.updateTaskStatus(taskId: task.id, status: status)
                self.task?.status = status
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
}
