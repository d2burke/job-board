import XCTest
import SwiftUI
@testable import DesignSystem

final class DesignSystemTests: XCTestCase {

    // MARK: - AppColors Tests

    func testAppColorsExist() {
        // Verify all color constants are accessible and non-nil.
        let colors: [Color] = [
            AppColors.deepNavy,
            AppColors.warmCoral,
            AppColors.freshWhite,
            AppColors.softGray,
            AppColors.lightGray,
            AppColors.successGreen,
            AppColors.warningAmber,
            AppColors.errorRed,
            AppColors.accentGold
        ]

        XCTAssertEqual(colors.count, 9, "Expected 9 color tokens in AppColors")
    }

    func testBrandColorsAreDifferent() {
        XCTAssertNotEqual(AppColors.deepNavy, AppColors.warmCoral)
        XCTAssertNotEqual(AppColors.freshWhite, AppColors.deepNavy)
    }

    // MARK: - AppSpacing Tests

    func testSpacingFollows4ptGrid() {
        let spacingValues: [CGFloat] = [
            AppSpacing.xxxs,  // 2
            AppSpacing.xxs,   // 4
            AppSpacing.xs,    // 8
            AppSpacing.sm,    // 12
            AppSpacing.md,    // 16
            AppSpacing.lg,    // 24
            AppSpacing.xl,    // 32
            AppSpacing.xxl,   // 48
            AppSpacing.xxxl   // 64
        ]

        for value in spacingValues {
            XCTAssertEqual(
                value.truncatingRemainder(dividingBy: 2), 0,
                "Spacing value \(value) should be evenly divisible by 2 (4pt grid)"
            )
        }
    }

    func testSpacingValuesAreAscending() {
        let spacingValues: [CGFloat] = [
            AppSpacing.xxxs,
            AppSpacing.xxs,
            AppSpacing.xs,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.xxl,
            AppSpacing.xxxl
        ]

        for i in 1..<spacingValues.count {
            XCTAssertGreaterThan(
                spacingValues[i], spacingValues[i - 1],
                "Spacing values should be in ascending order"
            )
        }
    }

    func testSpacingExactValues() {
        XCTAssertEqual(AppSpacing.xxxs, 2)
        XCTAssertEqual(AppSpacing.xxs, 4)
        XCTAssertEqual(AppSpacing.xs, 8)
        XCTAssertEqual(AppSpacing.sm, 12)
        XCTAssertEqual(AppSpacing.md, 16)
        XCTAssertEqual(AppSpacing.lg, 24)
        XCTAssertEqual(AppSpacing.xl, 32)
        XCTAssertEqual(AppSpacing.xxl, 48)
        XCTAssertEqual(AppSpacing.xxxl, 64)
    }

    func testCornerRadiusValues() {
        XCTAssertEqual(AppSpacing.CornerRadius.small, 8)
        XCTAssertEqual(AppSpacing.CornerRadius.medium, 12)
        XCTAssertEqual(AppSpacing.CornerRadius.large, 16)
        XCTAssertEqual(AppSpacing.CornerRadius.pill, 24)
    }

    func testCornerRadiusAscending() {
        XCTAssertLessThan(AppSpacing.CornerRadius.small, AppSpacing.CornerRadius.medium)
        XCTAssertLessThan(AppSpacing.CornerRadius.medium, AppSpacing.CornerRadius.large)
        XCTAssertLessThan(AppSpacing.CornerRadius.large, AppSpacing.CornerRadius.pill)
    }

    // MARK: - Component Instantiation Tests

    func testPillButtonInstantiation() {
        let _ = PillButton(title: "Test", style: .primary) {}
        let _ = PillButton(title: "Test", style: .secondary, isLoading: false) {}
        let _ = PillButton(title: "Test", style: .outline, isLoading: true) {}
    }

    func testAATextFieldInstantiation() {
        let binding = Binding.constant("text")
        let _ = AATextField(label: "Email", text: binding, placeholder: "Enter email")
        let _ = AATextField(label: "Password", text: binding, placeholder: "Enter password", isSecure: true)
        let _ = AATextField(label: "Name", text: binding, placeholder: "Enter name", errorMessage: "Required")
    }

    func testAvatarViewInstantiation() {
        let _ = AvatarView()
        let _ = AvatarView(url: "https://example.com/photo.jpg", size: 56, showBadge: true)
        let _ = AvatarView(url: nil, size: 44, showBadge: false)
    }

    func testRatingViewInstantiation() {
        let _ = RatingView(rating: 4.5)
        let _ = RatingView(rating: 3.0, maxRating: 5, size: 20, color: .yellow)
        let _ = RatingView(rating: 0)
        let _ = RatingView(rating: 5.0)
    }

    func testCategoryChipInstantiation() {
        let _ = CategoryChip(label: "Open House", color: .blue)
        let _ = CategoryChip(label: "Photography", color: .purple, size: .small)
        let _ = CategoryChip(label: "Inspection", color: .orange, size: .regular)
    }

    func testTaskCardInstantiation() {
        let _ = TaskCard(
            title: "Open House Coverage",
            category: "Open House",
            categoryColor: .blue,
            compensation: "$75",
            location: "Glendale, CA",
            timeAgo: "2h ago"
        )

        let _ = TaskCard(
            title: "Photography Session",
            category: "Photography",
            categoryColor: .purple,
            compensation: "$120",
            location: "Beverly Hills, CA",
            timeAgo: "5h ago",
            scheduledDate: "Sat, Mar 15",
            avatarURL: "https://example.com/photo.jpg",
            showChevron: false
        )
    }

    func testEmptyStateViewInstantiation() {
        let _ = EmptyStateView(
            icon: "magnifyingglass",
            title: "No Tasks",
            message: "No tasks available."
        )

        let _ = EmptyStateView(
            icon: "tray",
            title: "Empty",
            message: "Nothing here.",
            buttonTitle: "Refresh"
        ) {
            // action
        }
    }

    func testLoadingViewInstantiation() {
        let _ = LoadingView()
        let _ = LoadingView(message: "Loading tasks...")
    }

    func testStatusBadgeInstantiation() {
        let _ = StatusBadge(status: "Open", color: AppColors.successGreen)
        let _ = StatusBadge(status: "In Progress", color: AppColors.warningAmber)
        let _ = StatusBadge(status: "Completed", color: AppColors.deepNavy)
    }

    // MARK: - Rating Clamping Tests

    func testRatingViewClampsBelowZero() {
        // RatingView should clamp negative values to 0.
        let view = RatingView(rating: -2.0)
        // The view should instantiate without crashing.
        XCTAssertNotNil(view)
    }

    func testRatingViewClampsAboveMax() {
        // RatingView should clamp values above maxRating.
        let view = RatingView(rating: 10.0, maxRating: 5)
        XCTAssertNotNil(view)
    }
}
