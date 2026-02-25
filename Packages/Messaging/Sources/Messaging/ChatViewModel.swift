import Foundation
import Observation
import SharedModels
import Networking

// MARK: - ChatViewModel

@Observable
public final class ChatViewModel {

    // MARK: - State

    public var messages: [Message] = []
    public var messageText: String = ""
    public var isLoading: Bool = false
    public var conversation: Conversation
    public var currentUserId: String

    // MARK: - Dependencies

    private let messageService: MessageServiceProtocol

    // MARK: - Init

    public init(
        messageService: MessageServiceProtocol,
        conversation: Conversation,
        currentUser: User
    ) {
        self.messageService = messageService
        self.conversation = conversation
        self.currentUserId = currentUser.id
    }

    // MARK: - Actions

    public func loadMessages() {
        isLoading = true

        Task { @MainActor in
            do {
                let fetched = try await messageService.fetchMessages(conversationId: conversation.id)
                messages = fetched
                isLoading = false
            } catch {
                isLoading = false
            }
        }
    }

    public func sendMessage() {
        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let outgoingText = text
        messageText = ""

        Task { @MainActor in
            do {
                let sent = try await messageService.sendMessage(
                    conversationId: conversation.id,
                    text: outgoingText
                )
                messages.append(sent)
                conversation.lastMessage = outgoingText
                conversation.lastMessageAt = sent.timestamp
            } catch {
                // Restore text on failure so the user can retry
                messageText = outgoingText
            }
        }
    }

    public func markAsRead() {
        Task { @MainActor in
            do {
                try await messageService.markAsRead(conversationId: conversation.id)
                conversation.unreadCount = 0
                for index in messages.indices {
                    messages[index].isRead = true
                }
            } catch {
                // Silently fail — not critical
            }
        }
    }
}
