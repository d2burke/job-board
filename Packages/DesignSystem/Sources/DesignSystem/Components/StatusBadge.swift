import SwiftUI

/// A compact colored badge that displays a status label with a leading indicator dot.
///
/// Used to show task or request statuses such as "In Progress", "Completed",
/// "Pending", etc. The background renders at reduced opacity for a subtle look.
///
/// ```swift
/// StatusBadge(status: "In Progress", color: AppColors.warningAmber)
/// StatusBadge(status: "Completed", color: AppColors.successGreen)
/// ```
public struct StatusBadge: View {

    // MARK: - Properties

    private let status: String
    private let color: Color

    // MARK: - Init

    public init(status: String, color: Color) {
        self.status = status
        self.color = color
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: AppSpacing.xxs) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)

            Text(status)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(color)
        }
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.xxs + 1)
        .background(color.opacity(0.12))
        .clipShape(Capsule())
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: AppSpacing.sm) {
        StatusBadge(status: "Open", color: AppColors.successGreen)
        StatusBadge(status: "In Progress", color: AppColors.warningAmber)
        StatusBadge(status: "Completed", color: AppColors.deepNavy)
        StatusBadge(status: "Cancelled", color: AppColors.errorRed)
        StatusBadge(status: "Pending Review", color: .purple)
    }
    .padding(AppSpacing.md)
}
