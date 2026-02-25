import SharedModels

public protocol TaskServiceProtocol: Sendable {
    func fetchNearbyTasks(latitude: Double, longitude: Double, radiusMiles: Double) async throws -> [AgentTask]
    func fetchTaskDetail(id: String) async throws -> AgentTask
    func createTask(_ task: AgentTask) async throws -> AgentTask
    func applyForTask(taskId: String, message: String?) async throws
    func updateTaskStatus(taskId: String, status: TaskStatus) async throws
    func fetchMyPostedTasks() async throws -> [AgentTask]
    func fetchMyAssignedTasks() async throws -> [AgentTask]
}
