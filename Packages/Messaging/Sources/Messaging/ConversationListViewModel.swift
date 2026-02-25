import Foundation
import Observation
import SharedModels
import Networking

// MARK: - ConversationListViewModel

@Observable
public final class ConversationListViewModel {

    // MARK: - State

    public var conversations: [Conversation] = []
    public var isLoading: Bool = false
    public var errorMessage: String?

    // MARK: - Computed

    public var totalUnread: Int {
        conversations.reduce(0) { $0 + $1.unreadCount }
    }

    // MARK: - Dependencies

    private let messageService: MessageServiceProtocol

    // MARK: - Init

    public init(messageService: MessageServiceProtocol) {
        self.messageService = messageService
    }

    // MARK: - Actions

    public func loadConversations() {
        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            do {
                let fetched = try await messageService.fetchConversations()
                conversations = fetched
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
}
