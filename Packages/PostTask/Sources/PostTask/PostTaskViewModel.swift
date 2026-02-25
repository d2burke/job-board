import Foundation
import Observation
import SharedModels
import Networking

// MARK: - Post Task Steps

public enum PostTaskStep: Int, CaseIterable, Equatable {
    case category = 0
    case details = 1
    case pricing = 2
    case review = 3
    case submitted = 4

    public var title: String {
        switch self {
        case .category: return "Category"
        case .details: return "Details"
        case .pricing: return "Pricing"
        case .review: return "Review"
        case .submitted: return "Submitted"
        }
    }

    public var stepNumber: Int { rawValue + 1 }
    public static var totalEditableSteps: Int { 4 }
}

// MARK: - PostTaskViewModel

@Observable
public final class PostTaskViewModel {

    // MARK: - State

    public var currentStep: PostTaskStep = .category
    public var selectedCategory: TaskCategory?
    public var title: String = ""
    public var description: String = ""
    public var address: String = ""
    public var city: String = ""
    public var state: String = ""
    public var zipCode: String = ""
    public var scheduledDate: Date = Date().addingTimeInterval(86400)
    public var compensation: String = ""
    public var estimatedDuration: String = "1 hour"
    public var requirements: [String] = []
    public var newRequirement: String = ""
    public var isLoading: Bool = false
    public var errorMessage: String?

    // MARK: - Dependencies

    private let taskService: TaskServiceProtocol
    private let currentUser: User

    // MARK: - Init

    public init(taskService: TaskServiceProtocol, currentUser: User) {
        self.taskService = taskService
        self.currentUser = currentUser
    }

    // MARK: - Step Navigation

    public var canAdvance: Bool {
        switch currentStep {
        case .category:
            return selectedCategory != nil
        case .details:
            return !title.isEmpty && !description.isEmpty && !address.isEmpty && !city.isEmpty && !state.isEmpty && !zipCode.isEmpty
        case .pricing:
            return !compensation.isEmpty && (Double(compensation) ?? 0) > 0
        case .review:
            return true
        case .submitted:
            return false
        }
    }

    public func nextStep() {
        guard canAdvance else {
            errorMessage = validationMessage
            return
        }
        errorMessage = nil

        guard let nextIndex = PostTaskStep(rawValue: currentStep.rawValue + 1) else { return }
        currentStep = nextIndex
    }

    public func previousStep() {
        guard let prevIndex = PostTaskStep(rawValue: currentStep.rawValue - 1) else { return }
        errorMessage = nil
        currentStep = prevIndex
    }

    public func goToStep(_ step: PostTaskStep) {
        guard step.rawValue < currentStep.rawValue else { return }
        errorMessage = nil
        currentStep = step
    }

    // MARK: - Requirements

    public func addRequirement() {
        let trimmed = newRequirement.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        requirements.append(trimmed)
        newRequirement = ""
    }

    public func removeRequirement(at index: Int) {
        guard requirements.indices.contains(index) else { return }
        requirements.remove(at: index)
    }

    // MARK: - Submit

    public func submitTask() {
        guard canAdvance else { return }
        isLoading = true
        errorMessage = nil

        let task = AgentTask(
            title: title,
            description: description,
            category: selectedCategory ?? .other,
            status: .open,
            address: address,
            city: city,
            state: state,
            zipCode: zipCode,
            latitude: 30.2672,
            longitude: -97.7431,
            compensation: Double(compensation) ?? 0,
            estimatedDuration: estimatedDuration,
            postedBy: currentUser,
            scheduledFor: scheduledDate,
            requirements: requirements
        )

        Task { @MainActor in
            do {
                _ = try await taskService.createTask(task)
                isLoading = false
                currentStep = .submitted
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Validation Messages

    private var validationMessage: String? {
        switch currentStep {
        case .category:
            return "Please select a task category."
        case .details:
            if title.isEmpty { return "Please enter a task title." }
            if description.isEmpty { return "Please enter a description." }
            if address.isEmpty { return "Please enter an address." }
            if city.isEmpty { return "Please enter a city." }
            if state.isEmpty { return "Please enter a state." }
            if zipCode.isEmpty { return "Please enter a zip code." }
            return nil
        case .pricing:
            if compensation.isEmpty { return "Please enter compensation amount." }
            if (Double(compensation) ?? 0) <= 0 { return "Please enter a valid compensation amount." }
            return nil
        case .review, .submitted:
            return nil
        }
    }

    // MARK: - Computed

    public var formattedCompensation: String {
        guard let amount = Double(compensation) else { return "$0" }
        return String(format: "$%.0f", amount)
    }

    public var progressFraction: Double {
        Double(currentStep.rawValue) / Double(PostTaskStep.totalEditableSteps)
    }
}
