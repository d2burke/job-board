import SwiftUI
import SharedModels
import Networking

/// The root entry point for the Notifications feature module.
///
/// Displays the notification center with all user notifications.
public struct NotificationsModule: View {

    // MARK: - State

    @State private var viewModel: NotificationViewModel

    // MARK: - Init

    public init(notificationService: NotificationServiceProtocol) {
        _viewModel = State(
            initialValue: NotificationViewModel(notificationService: notificationService)
        )
    }

    // MARK: - Body

    public var body: some View {
        NavigationStack {
            NotificationCenterView(viewModel: viewModel)
        }
        .task {
            viewModel.loadNotifications()
        }
    }
}

// MARK: - Preview

#Preview {
    NotificationsModule(
        notificationService: MockNotificationService()
    )
}
