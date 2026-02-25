import SwiftUI

/// A card component for displaying a task preview in list or feed views.
///
/// Presents task information in a structured layout: category chip at the top,
/// title, location and time metadata, and compensation right-aligned.
/// All parameters are primitive types — no model objects.
///
/// ```swift
/// TaskCard(
///     title: "Open House Coverage",
///     category: "Open House",
///     categoryColor: .blue,
///     compensation: "$75",
///     location: "Beverly Hills, CA",
///     timeAgo: "2h ago"
/// )
/// ```
public struct TaskCard: View {

    // MARK: - Properties

    private let title: String
    private let category: String
    private let categoryColor: Color
    private let compensation: String
    private let location: String
    private let timeAgo: String
    private let scheduledDate: String?
    private let avatarURL: String?
    private let showChevron: Bool

    // MARK: - Init

    public init(
        title: String,
        category: String,
        categoryColor: Color,
        compensation: String,
        location: String,
        timeAgo: String,
        scheduledDate: String? = nil,
        avatarURL: String? = nil,
        showChevron: Bool = true
    ) {
        self.title = title
        self.category = category
        self.categoryColor = categoryColor
        self.compensation = compensation
        self.location = location
        self.timeAgo = timeAgo
        self.scheduledDate = scheduledDate
        self.avatarURL = avatarURL
        self.showChevron = showChevron
    }

    // MARK: - Body

    public var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.sm) {
            // Avatar (optional)
            if avatarURL != nil {
                AvatarView(url: avatarURL, size: 40)
            }

            // Main content
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                // Category chip
                CategoryChip(label: category, color: categoryColor, size: .small)

                // Title
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(AppColors.deepNavy)
                    .lineLimit(2)

                // Scheduled date (if present)
                if let scheduledDate {
                    HStack(spacing: AppSpacing.xxs) {
                        Image(systemName: "calendar")
                            .font(.system(size: 12))
                        Text(scheduledDate)
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundStyle(AppColors.deepNavy)
                }

                // Bottom row: location + time on left, compensation on right
                HStack {
                    HStack(spacing: AppSpacing.xxs) {
                        Image(systemName: "mappin")
                            .font(.system(size: 11))
                        Text(location)
                            .font(.system(size: 13))
                    }
                    .foregroundStyle(AppColors.softGray)

                    Text("·")
                        .foregroundStyle(AppColors.softGray)

                    Text(timeAgo)
                        .font(.system(size: 13))
                        .foregroundStyle(AppColors.softGray)

                    Spacer()

                    Text(compensation)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(AppColors.warmCoral)
                }
            }

            // Chevron
            if showChevron {
                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColors.softGray)
                    .padding(.top, AppSpacing.xxs)
            }
        }
        .padding(AppSpacing.md)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.medium))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Preview

#Preview("Task Cards") {
    ScrollView {
        VStack(spacing: AppSpacing.sm) {
            TaskCard(
                title: "Open House Coverage — 3BR Ranch in Glendale",
                category: "Open House",
                categoryColor: .blue,
                compensation: "$75",
                location: "Glendale, CA",
                timeAgo: "2h ago",
                scheduledDate: "Sat, Mar 15 at 1:00 PM"
            )

            TaskCard(
                title: "Property Photography",
                category: "Photography",
                categoryColor: .purple,
                compensation: "$120",
                location: "Beverly Hills, CA",
                timeAgo: "5h ago",
                avatarURL: "https://picsum.photos/200"
            )

            TaskCard(
                title: "Home Inspection Coordination",
                category: "Inspection",
                categoryColor: .orange,
                compensation: "$50",
                location: "Pasadena, CA",
                timeAgo: "1d ago",
                showChevron: false
            )
        }
        .padding(AppSpacing.md)
    }
    .background(AppColors.freshWhite)
}
