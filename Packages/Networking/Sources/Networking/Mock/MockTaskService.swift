import Foundation
import SharedModels

@MainActor
public final class MockTaskService: TaskServiceProtocol {
    private var tasks: [AgentTask]

    public init() {
        self.tasks = MockTasks.allTasks
    }

    nonisolated public func fetchNearbyTasks(latitude: Double, longitude: Double, radiusMiles: Double) async throws -> [AgentTask] {
        try await Task.sleep(for: .milliseconds(400))
        let allTasks = await MainActor.run { self.tasks }
        return allTasks.filter { $0.status == .open }
    }

    nonisolated public func fetchTaskDetail(id: String) async throws -> AgentTask {
        try await Task.sleep(for: .milliseconds(300))
        let allTasks = await MainActor.run { self.tasks }
        guard let task = allTasks.first(where: { $0.id == id }) else {
            throw NetworkingError.notFound
        }
        return task
    }

    nonisolated public func createTask(_ task: AgentTask) async throws -> AgentTask {
        try await Task.sleep(for: .milliseconds(400))
        await MainActor.run { self.tasks.append(task) }
        return task
    }

    nonisolated public func applyForTask(taskId: String, message: String?) async throws {
        try await Task.sleep(for: .milliseconds(300))
        await MainActor.run {
            if let index = self.tasks.firstIndex(where: { $0.id == taskId }) {
                self.tasks[index].assignedTo = MockUsers.currentUser
                self.tasks[index].status = .assigned
            }
        }
    }

    nonisolated public func updateTaskStatus(taskId: String, status: TaskStatus) async throws {
        try await Task.sleep(for: .milliseconds(300))
        await MainActor.run {
            if let index = self.tasks.firstIndex(where: { $0.id == taskId }) {
                self.tasks[index].status = status
            }
        }
    }

    nonisolated public func fetchMyPostedTasks() async throws -> [AgentTask] {
        try await Task.sleep(for: .milliseconds(300))
        let allTasks = await MainActor.run { self.tasks }
        return allTasks.filter { $0.postedBy.id == MockUsers.currentUser.id }
    }

    nonisolated public func fetchMyAssignedTasks() async throws -> [AgentTask] {
        try await Task.sleep(for: .milliseconds(300))
        let allTasks = await MainActor.run { self.tasks }
        return allTasks.filter { $0.assignedTo?.id == MockUsers.currentUser.id }
    }
}
