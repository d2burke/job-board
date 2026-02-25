import SwiftUI

/// Visual style for ``PillButton``.
public enum PillButtonStyle {
    /// Warm coral filled background with white text.
    case primary
    /// Deep navy filled background with white text.
    case secondary
    /// Transparent background with deep navy border and text.
    case outline
}

/// A full-width rounded pill-shaped button used for primary actions.
///
/// ```swift
/// PillButton(title: "Get Started", style: .primary) {
///     // handle tap
/// }
/// ```
public struct PillButton: View {

    // MARK: - Properties

    private let title: String
    private let style: PillButtonStyle
    private let isLoading: Bool
    private let action: () -> Void

    // MARK: - Init

    public init(
        title: String,
        style: PillButtonStyle = .primary,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.isLoading = isLoading
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: {
            if !isLoading {
                action()
            }
        }) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                } else {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(foregroundColor)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(backgroundColor)
            .clipShape(Capsule())
            .overlay {
                if style == .outline {
                    Capsule()
                        .strokeBorder(AppColors.deepNavy, lineWidth: 1.5)
                }
            }
        }
        .buttonStyle(.plain)
        .opacity(isLoading ? 0.8 : 1.0)
    }

    // MARK: - Computed Colors

    private var backgroundColor: Color {
        switch style {
        case .primary:
            return AppColors.warmCoral
        case .secondary:
            return AppColors.deepNavy
        case .outline:
            return .clear
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary, .secondary:
            return .white
        case .outline:
            return AppColors.deepNavy
        }
    }
}

// MARK: - Preview

#Preview("Primary") {
    VStack(spacing: AppSpacing.md) {
        PillButton(title: "Accept Task", style: .primary) {}
        PillButton(title: "View Profile", style: .secondary) {}
        PillButton(title: "Cancel", style: .outline) {}
        PillButton(title: "Loading...", style: .primary, isLoading: true) {}
    }
    .padding(AppSpacing.md)
}
