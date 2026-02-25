import SwiftUI

/// Size variants for ``CategoryChip``.
public enum CategoryChipSize {
    /// Compact chip with smaller text and tighter padding.
    case small
    /// Standard chip size.
    case regular
}

/// A pill-shaped badge used to display task categories or tags.
///
/// The chip renders the label text in the given `color` over a
/// translucent (15 % opacity) background of the same color.
///
/// ```swift
/// CategoryChip(label: "Open House", color: .blue)
/// ```
public struct CategoryChip: View {

    // MARK: - Properties

    private let label: String
    private let color: Color
    private let size: CategoryChipSize

    // MARK: - Init

    public init(
        label: String,
        color: Color,
        size: CategoryChipSize = .regular
    ) {
        self.label = label
        self.color = color
        self.size = size
    }

    // MARK: - Body

    public var body: some View {
        Text(label)
            .font(.system(size: fontSize, weight: .semibold))
            .foregroundStyle(color)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(color.opacity(0.15))
            .clipShape(Capsule())
    }

    // MARK: - Sizing

    private var fontSize: CGFloat {
        switch size {
        case .small: return 11
        case .regular: return 13
        }
    }

    private var horizontalPadding: CGFloat {
        switch size {
        case .small: return AppSpacing.xs
        case .regular: return AppSpacing.sm
        }
    }

    private var verticalPadding: CGFloat {
        switch size {
        case .small: return AppSpacing.xxs
        case .regular: return AppSpacing.xxs + 2
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: AppSpacing.sm) {
        HStack(spacing: AppSpacing.xs) {
            CategoryChip(label: "Open House", color: .blue)
            CategoryChip(label: "Photography", color: .purple)
            CategoryChip(label: "Inspection", color: .orange)
        }

        HStack(spacing: AppSpacing.xs) {
            CategoryChip(label: "Urgent", color: AppColors.warmCoral, size: .small)
            CategoryChip(label: "Staging", color: AppColors.successGreen, size: .small)
        }
    }
    .padding(AppSpacing.md)
}
