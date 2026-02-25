import SwiftUI

/// A read-only star rating display with half-star support.
///
/// Renders filled, half-filled, and empty stars based on the
/// provided `rating` value (0.0 to 5.0 by default).
///
/// ```swift
/// RatingView(rating: 4.5, size: 20)
/// ```
public struct RatingView: View {

    // MARK: - Properties

    private let rating: Double
    private let maxRating: Int
    private let size: CGFloat
    private let color: Color

    // MARK: - Init

    public init(
        rating: Double,
        maxRating: Int = 5,
        size: CGFloat = 16,
        color: Color = AppColors.accentGold
    ) {
        self.rating = min(max(rating, 0), Double(maxRating))
        self.maxRating = maxRating
        self.size = size
        self.color = color
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: AppSpacing.xxxs) {
            ForEach(1...maxRating, id: \.self) { index in
                starImage(for: index)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .foregroundStyle(color)
            }
        }
    }

    // MARK: - Helpers

    private func starImage(for index: Int) -> Image {
        let threshold = Double(index)

        if rating >= threshold {
            // Full star
            return Image(systemName: "star.fill")
        } else if rating >= threshold - 0.5 {
            // Half star
            return Image(systemName: "star.leadinghalf.filled")
        } else {
            // Empty star
            return Image(systemName: "star")
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(alignment: .leading, spacing: AppSpacing.sm) {
        RatingView(rating: 5.0)
        RatingView(rating: 4.5, size: 20)
        RatingView(rating: 3.0, size: 24, color: AppColors.warmCoral)
        RatingView(rating: 1.5, size: 16)
        RatingView(rating: 0, size: 16)
    }
    .padding(AppSpacing.md)
}
