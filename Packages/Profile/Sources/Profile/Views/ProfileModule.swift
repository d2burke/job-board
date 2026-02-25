import SwiftUI
import SharedModels
import Networking

/// The root entry point for the Profile feature module.
///
/// Displays the user profile with navigation to reviews, earnings, and editing.
public struct ProfileModule: View {

    // MARK: - State

    @State private var viewModel: ProfileViewModel

    // MARK: - Init

    public init(
        profileService: ProfileServiceProtocol,
        paymentService: PaymentServiceProtocol,
        user: User
    ) {
        _viewModel = State(
            initialValue: ProfileViewModel(
                profileService: profileService,
                paymentService: paymentService,
                user: user
            )
        )
    }

    // MARK: - Body

    public var body: some View {
        NavigationStack {
            ProfileView(viewModel: viewModel)
        }
        .task {
            viewModel.loadProfile()
            viewModel.loadReviews()
            viewModel.loadEarnings()
        }
    }
}

// MARK: - Preview

#Preview {
    ProfileModule(
        profileService: MockProfileService(),
        paymentService: MockPaymentService(),
        user: SharedModels.MockUsers.currentUser
    )
}
