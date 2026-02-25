import Testing
import Foundation
@testable import Profile
import SharedModels
import Networking

// MARK: - Synchronous Mock Profile Service

struct SyncMockProfileService: ProfileServiceProtocol {
    var userToReturn: User
    var reviewsToReturn: [Review] = []

    func fetchProfile(userId: String) async throws -> User {
        return userToReturn
    }

    func updateProfile(_ user: User) async throws -> User {
        return user
    }

    func fetchReviews(userId: String) async throws -> [Review] {
        return reviewsToReturn
    }
}

// MARK: - Synchronous Mock Payment Service

struct SyncMockPaymentService: PaymentServiceProtocol {
    var earningsToReturn: [Payment] = []
    var totalToReturn: Double = 0.0

    func fetchEarnings() async throws -> [Payment] {
        return earningsToReturn
    }

    func fetchTotalEarnings() async throws -> Double {
        return totalToReturn
    }

    func requestPayout(amount: Double) async throws {
        // No-op
    }
}

// MARK: - Tests

@Suite("ProfileViewModel Tests")
struct ProfileViewModelTests {

    // MARK: - Test Data

    private static var testUser: User {
        User(
            id: "user-test-001",
            firstName: "Test",
            lastName: "Agent",
            email: "test@example.com",
            phone: "(555) 000-0001",
            bio: "A test bio for the profile.",
            licenseNumber: "TX-99999999",
            brokerage: "Test Realty",
            specialties: [.openHouse, .photography],
            rating: 4.7,
            reviewCount: 25,
            completedTasks: 30,
            badges: [],
            isVerified: true
        )
    }

    private static var testReviews: [Review] {
        [
            Review(
                id: "review-t-001",
                taskId: "task-t-001",
                reviewerId: "user-other-001",
                revieweeId: "user-test-001",
                rating: 5.0,
                comment: "Excellent work on the open house.",
                createdAt: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
                reviewerName: "Sarah Chen"
            ),
            Review(
                id: "review-t-002",
                taskId: "task-t-002",
                reviewerId: "user-other-002",
                revieweeId: "user-test-001",
                rating: 4.0,
                comment: "Good photography, prompt delivery.",
                createdAt: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
                reviewerName: "Marcus Johnson"
            ),
            Review(
                id: "review-t-003",
                taskId: "task-t-003",
                reviewerId: "user-other-003",
                revieweeId: "user-test-001",
                rating: 3.5,
                comment: "Decent work but could improve communication.",
                createdAt: Calendar.current.date(byAdding: .day, value: -15, to: Date())!,
                reviewerName: "Emily Rodriguez"
            )
        ]
    }

    private static var testPayments: [Payment] {
        [
            Payment(
                id: "pay-t-001",
                taskId: "task-t-001",
                amount: 150.0,
                status: .completed,
                payerId: "user-other-001",
                payeeId: "user-test-001",
                createdAt: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
                taskTitle: "Open House at 123 Oak"
            ),
            Payment(
                id: "pay-t-002",
                taskId: "task-t-002",
                amount: 200.0,
                status: .completed,
                payerId: "user-other-002",
                payeeId: "user-test-001",
                createdAt: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
                taskTitle: "Photography at Lakeside"
            ),
            Payment(
                id: "pay-t-003",
                taskId: "task-t-003",
                amount: 100.0,
                status: .pending,
                payerId: "user-other-003",
                payeeId: "user-test-001",
                createdAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                taskTitle: "Inspection Walkthrough"
            )
        ]
    }

    // MARK: - Load Profile Tests

    @Test("loadProfile updates user from service")
    @MainActor
    func loadProfile() async {
        let profileService = SyncMockProfileService(
            userToReturn: ProfileViewModelTests.testUser
        )
        let paymentService = SyncMockPaymentService()
        let vm = ProfileViewModel(
            profileService: profileService,
            paymentService: paymentService,
            user: ProfileViewModelTests.testUser
        )

        vm.loadProfile()

        try? await Task.sleep(for: .milliseconds(100))

        #expect(vm.user.firstName == "Test")
        #expect(vm.user.lastName == "Agent")
        #expect(vm.user.isVerified == true)
        #expect(vm.isLoading == false)
    }

    // MARK: - Total Earnings Tests

    @Test("totalEarnings is correctly calculated from payment service")
    @MainActor
    func totalEarningsCalculation() async {
        let profileService = SyncMockProfileService(
            userToReturn: ProfileViewModelTests.testUser
        )
        let paymentService = SyncMockPaymentService(
            earningsToReturn: ProfileViewModelTests.testPayments,
            totalToReturn: 350.0 // 150 + 200 (only completed)
        )
        let vm = ProfileViewModel(
            profileService: profileService,
            paymentService: paymentService,
            user: ProfileViewModelTests.testUser
        )

        vm.loadEarnings()

        try? await Task.sleep(for: .milliseconds(100))

        #expect(vm.totalEarnings == 350.0)
        #expect(vm.earnings.count == 3)
    }

    // MARK: - Average Rating Tests

    @Test("averageRating computed from reviews")
    @MainActor
    func averageRating() async {
        let profileService = SyncMockProfileService(
            userToReturn: ProfileViewModelTests.testUser,
            reviewsToReturn: ProfileViewModelTests.testReviews
        )
        let paymentService = SyncMockPaymentService()
        let vm = ProfileViewModel(
            profileService: profileService,
            paymentService: paymentService,
            user: ProfileViewModelTests.testUser
        )

        vm.loadReviews()

        try? await Task.sleep(for: .milliseconds(100))

        // (5.0 + 4.0 + 3.5) / 3 = 4.166...
        let expected = (5.0 + 4.0 + 3.5) / 3.0
        #expect(abs(vm.averageRating - expected) < 0.01)
    }

    @Test("averageRating falls back to user rating when no reviews")
    func averageRatingFallback() {
        let profileService = SyncMockProfileService(
            userToReturn: ProfileViewModelTests.testUser,
            reviewsToReturn: []
        )
        let paymentService = SyncMockPaymentService()
        let vm = ProfileViewModel(
            profileService: profileService,
            paymentService: paymentService,
            user: ProfileViewModelTests.testUser
        )

        #expect(vm.averageRating == 4.7)
    }

    // MARK: - Edit Fields Tests

    @Test("populateEditFields copies user data correctly")
    func populateEditFields() {
        let profileService = SyncMockProfileService(
            userToReturn: ProfileViewModelTests.testUser
        )
        let paymentService = SyncMockPaymentService()
        let vm = ProfileViewModel(
            profileService: profileService,
            paymentService: paymentService,
            user: ProfileViewModelTests.testUser
        )

        #expect(vm.editFirstName == "Test")
        #expect(vm.editLastName == "Agent")
        #expect(vm.editBio == "A test bio for the profile.")
        #expect(vm.editLicenseNumber == "TX-99999999")
        #expect(vm.editBrokerage == "Test Realty")
        #expect(vm.editPhone == "(555) 000-0001")
        #expect(vm.editSpecialties.count == 2)
        #expect(vm.editSpecialties.contains(.openHouse))
        #expect(vm.editSpecialties.contains(.photography))
    }

    // MARK: - Toggle Specialty Tests

    @Test("toggleSpecialty adds and removes categories")
    func toggleSpecialty() {
        let profileService = SyncMockProfileService(
            userToReturn: ProfileViewModelTests.testUser
        )
        let paymentService = SyncMockPaymentService()
        let vm = ProfileViewModel(
            profileService: profileService,
            paymentService: paymentService,
            user: ProfileViewModelTests.testUser
        )

        // openHouse is already in specialties
        #expect(vm.editSpecialties.contains(.openHouse))

        vm.toggleSpecialty(.openHouse)
        #expect(!vm.editSpecialties.contains(.openHouse))

        vm.toggleSpecialty(.openHouse)
        #expect(vm.editSpecialties.contains(.openHouse))

        // staging is NOT in specialties
        #expect(!vm.editSpecialties.contains(.staging))

        vm.toggleSpecialty(.staging)
        #expect(vm.editSpecialties.contains(.staging))
    }

    // MARK: - Initial State Tests

    @Test("Initial state is correct")
    func initialState() {
        let profileService = SyncMockProfileService(
            userToReturn: ProfileViewModelTests.testUser
        )
        let paymentService = SyncMockPaymentService()
        let vm = ProfileViewModel(
            profileService: profileService,
            paymentService: paymentService,
            user: ProfileViewModelTests.testUser
        )

        #expect(vm.reviews.isEmpty)
        #expect(vm.earnings.isEmpty)
        #expect(vm.totalEarnings == 0.0)
        #expect(vm.isLoading == false)
        #expect(vm.isEditing == false)
        #expect(vm.user.id == "user-test-001")
    }
}
