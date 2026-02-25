import Foundation
import Observation
import SharedModels
import Networking

// MARK: - Sort Order

public enum TaskSortOrder: String, CaseIterable, Identifiable {
    case newest = "Newest"
    case closest = "Closest"
    case highestPay = "Highest Pay"

    public var id: String { rawValue }
}

// MARK: - TaskListViewModel

@Observable
public final class TaskListViewModel {

    // MARK: - State

    public var tasks: [AgentTask] = []
    public var filteredTasks: [AgentTask] = []
    public var isLoading: Bool = false
    public var errorMessage: String?
    public var searchText: String = "" {
        didSet { applyFilters() }
    }
    public var selectedCategories: Set<TaskCategory> = [] {
        didSet { applyFilters() }
    }
    public var sortOrder: TaskSortOrder = .newest {
        didSet { applyFilters() }
    }
    public var showMapView: Bool = false
    public var maxDistanceMiles: Double = 25

    // MARK: - Dependencies

    private let taskService: TaskServiceProtocol

    // MARK: - Init

    public init(taskService: TaskServiceProtocol) {
        self.taskService = taskService
    }

    // MARK: - Actions

    public func loadTasks() {
        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            do {
                let fetched = try await taskService.fetchNearbyTasks(
                    latitude: 30.2672,
                    longitude: -97.7431,
                    radiusMiles: maxDistanceMiles
                )
                tasks = fetched
                applyFilters()
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }

    public func applyFilters() {
        var result = tasks

        // Filter by search text
        if !searchText.isEmpty {
            let query = searchText.lowercased()
            result = result.filter { task in
                task.title.lowercased().contains(query) ||
                task.description.lowercased().contains(query) ||
                task.city.lowercased().contains(query) ||
                task.category.displayName.lowercased().contains(query)
            }
        }

        // Filter by selected categories
        if !selectedCategories.isEmpty {
            result = result.filter { selectedCategories.contains($0.category) }
        }

        // Sort
        switch sortOrder {
        case .newest:
            result.sort { $0.createdAt > $1.createdAt }
        case .closest:
            // Sort by proximity (simplified: use latitude difference)
            let userLat = 30.2672
            result.sort {
                abs($0.latitude - userLat) < abs($1.latitude - userLat)
            }
        case .highestPay:
            result.sort { $0.compensation > $1.compensation }
        }

        filteredTasks = result
    }

    public func toggleCategory(_ category: TaskCategory) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }

    public func setSortOrder(_ order: TaskSortOrder) {
        sortOrder = order
    }

    public func resetFilters() {
        selectedCategories = []
        sortOrder = .newest
        searchText = ""
        maxDistanceMiles = 25
    }
}
