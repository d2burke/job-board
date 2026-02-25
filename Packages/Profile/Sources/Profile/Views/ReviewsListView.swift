import SwiftUI
import SharedModels
import Networking
import DesignSystem

/// Displays reviews received by the user with an average rating summary.
public struct ReviewsListView: View {

    // MARK: - Properties

    @Bindable var viewModel: ProfileViewModel

    // MARK: - Init

    public init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    public var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                ratingSummary
                reviewCards
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.top, AppSpacing.sm)
            .padding(.bottom, AppSpacing.xl)
        }
        .background(AppColors.freshWhite)
        .navigationTitle("Reviews")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.loadReviews()
        }
    }

    // MARK: - Rating Summary

    private var ratingSummary: some View {
        VStack(spacing: AppSpacing.xs) {
            Text(String(format: "%.1f", viewModel.averageRating))
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(AppColors.deepNavy)

            RatingView(rating: viewModel.averageRating, size: 24)

            Text("(\(viewModel.reviews.count) reviews)")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(AppColors.softGray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.lg)
    }

    // MARK: - Review Cards

    @ViewBuilder
    private var reviewCards: some View {
        if viewModel.reviews.isEmpty {
            EmptyStateView(
                icon: "star.bubble",
                title: "No Reviews Yet",
                message: "Reviews from agents you've worked with will appear here."
            )
            .frame(height: 250)
        } else {
            LazyVStack(spacing: AppSpacing.sm) {
                ForEach(viewModel.reviews) { review in
                    reviewCard(review)
                }
            }
        }
    }

    private func reviewCard(_ review: Review) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack(spacing: AppSpacing.sm) {
                AvatarView(
                    url: review.reviewerAvatarURL,
                    size: 40
                )

                VStack(alignment: .leading, spacing: AppSpacing.xxxs) {
                    Text(review.reviewerName)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(AppColors.deepNavy)

                    RatingView(rating: review.rating, size: 14)
                }

                Spacer()

                Text(formatDate(review.createdAt))
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(AppColors.softGray)
            }

            Text(review.comment)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(AppColors.deepNavy.opacity(0.85))
                .lineSpacing(3)
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.medium))
        .shadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)
    }

    // MARK: - Helpers

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ReviewsListView(
            viewModel: {
                let vm = ProfileViewModel(
                    profileService: MockProfileService(),
                    paymentService: MockPaymentService(),
                    user: SharedModels.MockUsers.currentUser
                )
                vm.loadReviews()
                return vm
            }()
        )
    }
}
