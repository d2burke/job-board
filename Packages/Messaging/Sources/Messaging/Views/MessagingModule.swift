import SwiftUI
import SharedModels
import Networking

/// The root entry point for the Messaging feature module.
///
/// Displays the conversation list with navigation into individual chat threads.
public struct MessagingModule: View {

    // MARK: - State

    @State private var listViewModel: ConversationListViewModel
    private let messageService: MessageServiceProtocol
    private let currentUser: User

    // MARK: - Init

    public init(messageService: MessageServiceProtocol, currentUser: User) {
        self.messageService = messageService
        self.currentUser = currentUser
        _listViewModel = State(
            initialValue: ConversationListViewModel(messageService: messageService)
        )
    }

    // MARK: - Body

    public var body: some View {
        NavigationStack {
            ConversationListView(
                viewModel: listViewModel,
                messageService: messageService,
                currentUser: currentUser
            )
        }
        .task {
            listViewModel.loadConversations()
        }
    }
}

// MARK: - Preview

#Preview {
    MessagingModule(
        messageService: MockMessageService(),
        currentUser: SharedModels.MockUsers.currentUser
    )
}
