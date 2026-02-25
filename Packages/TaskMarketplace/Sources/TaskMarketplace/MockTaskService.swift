import Foundation
import SharedModels
import Networking

/// Mock task service providing sample data for previews and tests.
public struct MockTaskService: TaskServiceProtocol {

    public init() {}

    // MARK: - Sample Tasks

    public static let sampleTasks: [AgentTask] = [
        AgentTask(
            id: "task-001",
            title: "Open House Coverage - 3BR Ranch in Westlake",
            description: "Looking for a licensed agent to host an open house for a beautiful 3-bedroom ranch home in the Westlake Hills area. Property is staged and ready. You will need to greet visitors, collect contact information, and provide property information sheets.",
            category: .openHouse,
            status: .open,
            address: "2401 Westlake Dr",
            city: "Austin",
            state: "TX",
            zipCode: "78746",
            latitude: 30.3074,
            longitude: -97.7977,
            compensation: 150,
            estimatedDuration: "3 hours",
            postedBy: MockUsers.sarah,
            createdAt: Date().addingTimeInterval(-7200),
            scheduledFor: Date().addingTimeInterval(86400 * 2),
            requirements: [
                "Active Texas real estate license",
                "Professional attire required",
                "Must arrive 30 minutes early for setup",
                "Familiarity with Westlake area preferred"
            ]
        ),
        AgentTask(
            id: "task-002",
            title: "Property Photography - Downtown Condo",
            description: "Need professional-quality photos of a newly renovated 2BR/2BA downtown condo for MLS listing. Must include wide-angle shots of all rooms, balcony views, building amenities, and street-level exterior shots. Deliver edited photos within 24 hours.",
            category: .photography,
            status: .open,
            address: "360 Nueces St",
            city: "Austin",
            state: "TX",
            zipCode: "78701",
            latitude: 30.2672,
            longitude: -97.7431,
            compensation: 200,
            estimatedDuration: "2 hours",
            postedBy: MockUsers.emily,
            createdAt: Date().addingTimeInterval(-18000),
            scheduledFor: Date().addingTimeInterval(86400),
            requirements: [
                "Professional camera equipment required",
                "Experience with real estate photography",
                "Photo editing and delivery within 24 hours",
                "Minimum 30 edited photos"
            ]
        ),
        AgentTask(
            id: "task-003",
            title: "Home Inspection Coordination",
            description: "Need someone to be present during a scheduled home inspection at a 4-bedroom property in Round Rock. You will meet the inspector, provide access to the property, and take notes during the inspection process.",
            category: .inspection,
            status: .open,
            address: "1205 Gattis School Rd",
            city: "Round Rock",
            state: "TX",
            zipCode: "78664",
            latitude: 30.5083,
            longitude: -97.6789,
            compensation: 75,
            estimatedDuration: "2.5 hours",
            postedBy: MockUsers.marcus,
            createdAt: Date().addingTimeInterval(-36000),
            scheduledFor: Date().addingTimeInterval(86400 * 3),
            requirements: [
                "Must be punctual",
                "Bring lockbox code (will be provided)",
                "Take detailed notes",
                "Send summary report after inspection"
            ]
        ),
        AgentTask(
            id: "task-004",
            title: "Staging Consultation - Lakeway Estate",
            description: "Looking for an experienced stager to provide a consultation for a luxury lakefront property. The seller wants recommendations on furniture arrangement, decor updates, and curb appeal improvements before listing.",
            category: .staging,
            status: .open,
            address: "500 Lakeway Dr",
            city: "Lakeway",
            state: "TX",
            zipCode: "78734",
            latitude: 30.3644,
            longitude: -97.9792,
            compensation: 300,
            estimatedDuration: "4 hours",
            postedBy: MockUsers.jessica,
            createdAt: Date().addingTimeInterval(-43200),
            scheduledFor: Date().addingTimeInterval(86400 * 5),
            requirements: [
                "Staging certification or extensive experience",
                "Provide written report with recommendations",
                "Include rough cost estimates for changes",
                "Before/after visualization preferred"
            ]
        ),
        AgentTask(
            id: "task-005",
            title: "Install Yard Signs - 5 Properties",
            description: "Need someone to install 'For Sale' yard signs at 5 properties across South Austin. Signs and posts will be provided. Must install securely and take a photo of each installation for confirmation.",
            category: .signInstall,
            status: .open,
            address: "Multiple Locations",
            city: "Austin",
            state: "TX",
            zipCode: "78745",
            latitude: 30.2100,
            longitude: -97.7700,
            compensation: 100,
            estimatedDuration: "2 hours",
            postedBy: MockUsers.carlos,
            createdAt: Date().addingTimeInterval(-50400),
            scheduledFor: Date().addingTimeInterval(86400),
            requirements: [
                "Must have vehicle for transportation",
                "Basic tools for installation",
                "Photo confirmation of each installation",
                "Complete all 5 in one trip"
            ]
        ),
        AgentTask(
            id: "task-006",
            title: "Buyer Showing - 3 Properties in Cedar Park",
            description: "Represent a pre-qualified buyer for showings at 3 properties in Cedar Park. Buyer is relocating from out of state and needs a knowledgeable local agent to provide guided tours and neighborhood insights.",
            category: .showing,
            status: .open,
            address: "Cedar Park Area",
            city: "Cedar Park",
            state: "TX",
            zipCode: "78613",
            latitude: 30.5052,
            longitude: -97.8203,
            compensation: 125,
            estimatedDuration: "3 hours",
            postedBy: MockUsers.david,
            createdAt: Date().addingTimeInterval(-64800),
            scheduledFor: Date().addingTimeInterval(86400 * 4),
            requirements: [
                "Active Texas real estate license",
                "Knowledge of Cedar Park neighborhoods",
                "Professional and punctual",
                "Provide feedback report to listing agent"
            ]
        )
    ]

    // MARK: - Protocol

    public func fetchNearbyTasks(latitude: Double, longitude: Double, radiusMiles: Double) async throws -> [AgentTask] {
        try await Task.sleep(for: .seconds(0.8))
        return Self.sampleTasks
    }

    public func fetchTaskDetail(id: String) async throws -> AgentTask {
        try await Task.sleep(for: .seconds(0.5))
        guard let task = Self.sampleTasks.first(where: { $0.id == id }) else {
            throw NSError(domain: "TaskService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Task not found"])
        }
        return task
    }

    public func createTask(_ task: AgentTask) async throws -> AgentTask {
        try await Task.sleep(for: .seconds(1))
        return task
    }

    public func applyForTask(taskId: String, message: String?) async throws {
        try await Task.sleep(for: .seconds(1))
    }

    public func updateTaskStatus(taskId: String, status: TaskStatus) async throws {
        try await Task.sleep(for: .seconds(0.5))
    }

    public func fetchMyPostedTasks() async throws -> [AgentTask] {
        try await Task.sleep(for: .seconds(0.5))
        return Array(Self.sampleTasks.prefix(2))
    }

    public func fetchMyAssignedTasks() async throws -> [AgentTask] {
        try await Task.sleep(for: .seconds(0.5))
        return Array(Self.sampleTasks.suffix(2))
    }
}
