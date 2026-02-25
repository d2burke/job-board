import Foundation
import Observation
import SharedModels
import Networking

// MARK: - ProfileViewModel

@Observable
public final class ProfileViewModel {

    // MARK: - State

    public var user: User
    public var reviews: [Review] = []
    public var earnings: [Payment] = []
    public var totalEarnings: Double = 0.0
    public var isLoading: Bool = false
    public var isEditing: Bool = false
    public var errorMessage: String?

    // MARK: - Editable fields (for Edit Profile sheet)

    public var editFirstName: String = ""
    public var editLastName: String = ""
    public var editBio: String = ""
    public var editLicenseNumber: String = ""
    public var editBrokerage: String = ""
    public var editPhone: String = ""
    public var editSpecialties: Set<TaskCategory> = []

    // MARK: - Dependencies

    private let profileService: ProfileServiceProtocol
    private let paymentService: PaymentServiceProtocol
    public var onSignOut: (() -> Void)?

    // MARK: - Init

    public init(
        profileService: ProfileServiceProtocol,
        paymentService: PaymentServiceProtocol,
        user: User,
        onSignOut: (() -> Void)? = nil
    ) {
        self.profileService = profileService
        self.paymentService = paymentService
        self.user = user
        self.onSignOut = onSignOut
        populateEditFields()
    }

    // MARK: - Actions

    public func loadProfile() {
        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            do {
                let fetched = try await profileService.fetchProfile(userId: user.id)
                user = fetched
                populateEditFields()
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }

    public func loadReviews() {
        Task { @MainActor in
            do {
                let fetched = try await profileService.fetchReviews(userId: user.id)
                reviews = fetched.sorted { $0.createdAt > $1.createdAt }
            } catch {
                // Silently handle — reviews are supplementary
            }
        }
    }

    public func loadEarnings() {
        Task { @MainActor in
            do {
                let fetchedEarnings = try await paymentService.fetchEarnings()
                let fetchedTotal = try await paymentService.fetchTotalEarnings()
                earnings = fetchedEarnings
                totalEarnings = fetchedTotal
            } catch {
                // Silently handle — earnings are supplementary
            }
        }
    }

    public func saveProfile() {
        isLoading = true

        var updatedUser = user
        updatedUser.firstName = editFirstName
        updatedUser.lastName = editLastName
        updatedUser.bio = editBio
        updatedUser.licenseNumber = editLicenseNumber.isEmpty ? nil : editLicenseNumber
        updatedUser.brokerage = editBrokerage.isEmpty ? nil : editBrokerage
        updatedUser.phone = editPhone
        updatedUser.specialties = Array(editSpecialties)

        Task { @MainActor in
            do {
                let saved = try await profileService.updateProfile(updatedUser)
                user = saved
                isEditing = false
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Computed

    public var averageRating: Double {
        guard !reviews.isEmpty else { return user.rating }
        return reviews.reduce(0.0) { $0 + $1.rating } / Double(reviews.count)
    }

    public var thisMonthEarnings: [Payment] {
        let calendar = Calendar.current
        let now = Date()
        return earnings.filter { calendar.isDate($0.createdAt, equalTo: now, toGranularity: .month) }
    }

    public var thisMonthTotal: Double {
        thisMonthEarnings
            .filter { $0.status == .completed }
            .reduce(0.0) { $0 + $1.amount }
    }

    // MARK: - Helpers

    public func populateEditFields() {
        editFirstName = user.firstName
        editLastName = user.lastName
        editBio = user.bio
        editLicenseNumber = user.licenseNumber ?? ""
        editBrokerage = user.brokerage ?? ""
        editPhone = user.phone
        editSpecialties = Set(user.specialties)
    }

    public func toggleSpecialty(_ category: TaskCategory) {
        if editSpecialties.contains(category) {
            editSpecialties.remove(category)
        } else {
            editSpecialties.insert(category)
        }
    }
}
