import SwiftUI

/// A centered loading indicator with an optional descriptive message.
///
/// Use this as a full-screen or inline placeholder while content loads.
///
/// ```swift
/// LoadingView(message: "Fetching tasks...")
/// ```
public struct LoadingView: View {

    // MARK: - Properties

    private let message: String?

    // MARK: - Init

    public init(message: String? = nil) {
        self.message = message
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: AppSpacing.md) {
            Spacer()

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: AppColors.deepNavy))
                .scaleEffect(1.2)

            if let message {
                Text(message)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppColors.softGray)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(AppSpacing.md)
    }
}

// MARK: - Preview

#Preview("With Message") {
    LoadingView(message: "Fetching tasks near you...")
}

#Preview("Without Message") {
    LoadingView()
}
