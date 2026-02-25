import Testing
import Foundation
@testable import PostTask
import SharedModels
import Networking

// MARK: - Instant Mock Task Service

struct InstantMockTaskService: TaskServiceProtocol {
    var shouldFail = false

    func fetchNearbyTasks(latitude: Double, longitude: Double, radiusMiles: Double) async throws -> [AgentTask] { [] }
    func fetchTaskDetail(id: String) async throws -> AgentTask {
        throw NSError(domain: "", code: 404)
    }
    func createTask(_ task: AgentTask) async throws -> AgentTask {
        if shouldFail { throw NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"]) }
        return task
    }
    func applyForTask(taskId: String, message: String?) async throws {}
    func updateTaskStatus(taskId: String, status: TaskStatus) async throws {}
    func fetchMyPostedTasks() async throws -> [AgentTask] { [] }
    func fetchMyAssignedTasks() async throws -> [AgentTask] { [] }
}

// MARK: - Tests

@Suite("PostTaskViewModel Tests")
struct PostTaskViewModelTests {

    private func makeViewModel(shouldFail: Bool = false) -> PostTaskViewModel {
        PostTaskViewModel(
            taskService: InstantMockTaskService(shouldFail: shouldFail),
            currentUser: MockUsers.currentUser
        )
    }

    @Test("Initial step is category")
    func initialStep() {
        let vm = makeViewModel()
        #expect(vm.currentStep == .category)
    }

    @Test("Cannot advance from category without selection")
    func cannotAdvanceWithoutCategory() {
        let vm = makeViewModel()
        vm.nextStep()
        #expect(vm.currentStep == .category)
        #expect(vm.errorMessage != nil)
    }

    @Test("Can advance from category with selection")
    func canAdvanceWithCategory() {
        let vm = makeViewModel()
        vm.selectedCategory = .openHouse
        vm.nextStep()
        #expect(vm.currentStep == .details)
        #expect(vm.errorMessage == nil)
    }

    @Test("Cannot advance from details with empty fields")
    func cannotAdvanceWithEmptyDetails() {
        let vm = makeViewModel()
        vm.selectedCategory = .openHouse
        vm.nextStep() // -> details
        vm.nextStep() // should stay on details
        #expect(vm.currentStep == .details)
        #expect(vm.errorMessage != nil)
    }

    @Test("Can advance from details with all fields filled")
    func canAdvanceWithDetails() {
        let vm = makeViewModel()
        vm.selectedCategory = .openHouse
        vm.nextStep()
        vm.title = "Test Task"
        vm.description = "A description"
        vm.address = "123 Main St"
        vm.city = "Austin"
        vm.state = "TX"
        vm.zipCode = "78701"
        vm.nextStep()
        #expect(vm.currentStep == .pricing)
    }

    @Test("Cannot advance from pricing without compensation")
    func cannotAdvanceWithoutCompensation() {
        let vm = makeViewModel()
        vm.selectedCategory = .openHouse
        vm.nextStep()
        vm.title = "Test"
        vm.description = "Desc"
        vm.address = "123 Main"
        vm.city = "Austin"
        vm.state = "TX"
        vm.zipCode = "78701"
        vm.nextStep() // -> pricing
        vm.nextStep() // should stay on pricing
        #expect(vm.currentStep == .pricing)
        #expect(vm.errorMessage != nil)
    }

    @Test("previousStep navigates backward")
    func previousStep() {
        let vm = makeViewModel()
        vm.selectedCategory = .openHouse
        vm.nextStep() // -> details
        vm.previousStep() // -> category
        #expect(vm.currentStep == .category)
    }

    @Test("addRequirement appends to list")
    func addRequirement() {
        let vm = makeViewModel()
        vm.newRequirement = "Must have license"
        vm.addRequirement()
        #expect(vm.requirements.count == 1)
        #expect(vm.requirements.first == "Must have license")
        #expect(vm.newRequirement.isEmpty)
    }

    @Test("addRequirement ignores empty string")
    func addEmptyRequirement() {
        let vm = makeViewModel()
        vm.newRequirement = "   "
        vm.addRequirement()
        #expect(vm.requirements.isEmpty)
    }

    @Test("removeRequirement removes at index")
    func removeRequirement() {
        let vm = makeViewModel()
        vm.newRequirement = "Requirement 1"
        vm.addRequirement()
        vm.newRequirement = "Requirement 2"
        vm.addRequirement()
        vm.removeRequirement(at: 0)
        #expect(vm.requirements.count == 1)
        #expect(vm.requirements.first == "Requirement 2")
    }

    @Test("goToStep navigates backward only")
    func goToStep() {
        let vm = makeViewModel()
        vm.selectedCategory = .openHouse
        vm.nextStep() // -> details
        vm.title = "Test"
        vm.description = "Desc"
        vm.address = "123"
        vm.city = "Austin"
        vm.state = "TX"
        vm.zipCode = "78701"
        vm.nextStep() // -> pricing
        vm.goToStep(.category)
        #expect(vm.currentStep == .category)
    }

    @Test("formattedCompensation formats correctly")
    func formattedCompensation() {
        let vm = makeViewModel()
        vm.compensation = "150"
        #expect(vm.formattedCompensation == "$150")
    }

    @Test("progressFraction calculates correctly")
    func progressFraction() {
        let vm = makeViewModel()
        #expect(vm.progressFraction == 0.0)
        vm.selectedCategory = .openHouse
        vm.nextStep()
        #expect(vm.progressFraction == 0.25)
    }
}
