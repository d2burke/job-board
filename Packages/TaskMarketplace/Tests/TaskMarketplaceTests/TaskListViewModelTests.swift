import Testing
import Foundation
@testable import TaskMarketplace
import SharedModels
import Networking

// MARK: - Synchronous Mock Task Service

struct SyncMockTaskService: TaskServiceProtocol {
    var tasksToReturn: [AgentTask] = MockTaskService.sampleTasks

    func fetchNearbyTasks(latitude: Double, longitude: Double, radiusMiles: Double) async throws -> [AgentTask] {
        return tasksToReturn
    }

    func fetchTaskDetail(id: String) async throws -> AgentTask {
        guard let task = tasksToReturn.first(where: { $0.id == id }) else {
            throw NSError(domain: "", code: 404)
        }
        return task
    }

    func createTask(_ task: AgentTask) async throws -> AgentTask { task }
    func applyForTask(taskId: String, message: String?) async throws {}
    func updateTaskStatus(taskId: String, status: TaskStatus) async throws {}
    func fetchMyPostedTasks() async throws -> [AgentTask] { [] }
    func fetchMyAssignedTasks() async throws -> [AgentTask] { [] }
}

// MARK: - Tests

@Suite("TaskListViewModel Tests")
struct TaskListViewModelTests {

    @Test("Initial state has empty tasks")
    func initialState() {
        let vm = TaskListViewModel(taskService: SyncMockTaskService())
        #expect(vm.tasks.isEmpty)
        #expect(vm.filteredTasks.isEmpty)
        #expect(vm.showMapView == false)
        #expect(vm.sortOrder == .newest)
    }

    @Test("applyFilters filters by category")
    func filterByCategory() {
        let vm = TaskListViewModel(taskService: SyncMockTaskService())
        vm.tasks = MockTaskService.sampleTasks
        vm.selectedCategories = [.openHouse]

        let openHouseTasks = vm.filteredTasks.filter { $0.category == .openHouse }
        #expect(vm.filteredTasks.count == openHouseTasks.count)
        #expect(vm.filteredTasks.allSatisfy { $0.category == .openHouse })
    }

    @Test("applyFilters filters by search text")
    func filterBySearchText() {
        let vm = TaskListViewModel(taskService: SyncMockTaskService())
        vm.tasks = MockTaskService.sampleTasks
        vm.searchText = "photography"

        #expect(vm.filteredTasks.allSatisfy {
            $0.title.lowercased().contains("photography") ||
            $0.description.lowercased().contains("photography") ||
            $0.category.displayName.lowercased().contains("photography")
        })
    }

    @Test("Sort order highestPay sorts by compensation descending")
    func sortByHighestPay() {
        let vm = TaskListViewModel(taskService: SyncMockTaskService())
        vm.tasks = MockTaskService.sampleTasks
        vm.sortOrder = .highestPay

        for i in 0..<(vm.filteredTasks.count - 1) {
            #expect(vm.filteredTasks[i].compensation >= vm.filteredTasks[i + 1].compensation)
        }
    }

    @Test("toggleCategory adds and removes")
    func toggleCategory() {
        let vm = TaskListViewModel(taskService: SyncMockTaskService())
        vm.tasks = MockTaskService.sampleTasks

        vm.toggleCategory(.photography)
        #expect(vm.selectedCategories.contains(.photography))

        vm.toggleCategory(.photography)
        #expect(!vm.selectedCategories.contains(.photography))
    }

    @Test("resetFilters clears all filters")
    func resetFilters() {
        let vm = TaskListViewModel(taskService: SyncMockTaskService())
        vm.tasks = MockTaskService.sampleTasks
        vm.selectedCategories = [.openHouse, .photography]
        vm.searchText = "test"
        vm.sortOrder = .highestPay
        vm.maxDistanceMiles = 10

        vm.resetFilters()

        #expect(vm.selectedCategories.isEmpty)
        #expect(vm.searchText.isEmpty)
        #expect(vm.sortOrder == .newest)
        #expect(vm.maxDistanceMiles == 25)
    }
}
