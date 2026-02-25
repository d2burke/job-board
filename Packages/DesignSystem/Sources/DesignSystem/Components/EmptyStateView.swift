import SwiftUI

/// A centered placeholder view displayed when a list or screen has no content.
///
/// Shows an SF Symbol icon, title, descriptive message, and an optional
/// action button. Useful for empty lists, search results, and error states.
///
/// ```swift
/// EmptyStateView(
///     icon: "magnifyingglass",
///     title: "No Tasks Found",
///     message: "Try adjusting your filters or check back later.",
///     buttonTitle: "Reset Filters"
/// ) {
///     // reset filters action
/// }
/// ```
public struct EmptyStateView: View {

    // MARK: - Properties

    private let icon: String
    private let title: String
    private let message: String
    private let buttonTitle: String?
    private let buttonAction: (() -> Void)?

    // MARK: - Init

    public init(
        icon: String,
        title: String,
        message: String,
        buttonTitle: String? = nil,
        buttonAction: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: AppSpacing.md) {
            Spacer()

            // Icon
            Image(systemName: icon)
                .font(.system(size: 56, weight: .light))
                .foregroundStyle(AppColors.softGray)
                .padding(.bottom, AppSpacing.xs)

            // Title
            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppColors.deepNavy)
                .multilineTextAlignment(.center)

            // Message
            Text(message)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(AppColors.softGray)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, AppSpacing.xl)

            // Optional action button
            if let buttonTitle, let buttonAction {
                PillButton(title: buttonTitle, style: .outline, action: buttonAction)
                    .padding(.horizontal, AppSpacing.xxl)
                    .padding(.top, AppSpacing.xs)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(AppSpacing.md)
    }
}

// MARK: - Preview

#Preview("With Button") {
    EmptyStateView(
        icon: "magnifyingglass",
        title: "No Tasks Found",
        message: "Try adjusting your filters or check back later for new tasks in your area.",
        buttonTitle: "Reset Filters"
    ) {
        // action
    }
}

#Preview("Without Button") {
    EmptyStateView(
        icon: "tray",
        title: "All Caught Up",
        message: "You have no pending tasks right now. New tasks will appear here as they become available."
    )
}
