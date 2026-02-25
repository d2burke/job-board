import SwiftUI
import SharedModels
import Networking
import DesignSystem

/// The main profile screen showing user information, stats, specialties, and badges.
public struct ProfileView: View {

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
                headerSection
                statsRow
                bioSection
                specialtiesSection
                badgesSection
                navigationLinks
                signOutButton
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.top, AppSpacing.sm)
            .padding(.bottom, AppSpacing.xl)
        }
        .background(AppColors.freshWhite)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit Profile") {
                    viewModel.populateEditFields()
                    viewModel.isEditing = true
                }
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(AppColors.warmCoral)
            }
        }
        .sheet(isPresented: $viewModel.isEditing) {
            EditProfileView(viewModel: viewModel)
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: AppSpacing.sm) {
            AvatarView(
                url: viewModel.user.avatarURL,
                size: 80,
                showBadge: viewModel.user.isVerified
            )

            VStack(spacing: AppSpacing.xxs) {
                Text(viewModel.user.fullName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(AppColors.deepNavy)

                if let brokerage = viewModel.user.brokerage, !brokerage.isEmpty {
                    Text(brokerage)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(AppColors.softGray)
                }

                if viewModel.user.isVerified {
                    HStack(spacing: AppSpacing.xxs) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.blue)
                        Text("Verified Agent")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.blue)
                    }
                    .padding(.top, AppSpacing.xxxs)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.sm)
    }

    // MARK: - Stats Row

    private var statsRow: some View {
        HStack(spacing: 0) {
            statItem(
                value: "\(viewModel.user.completedTasks)",
                label: "Tasks"
            )

            Divider()
                .frame(height: 40)

            statItemWithRating(
                value: String(format: "%.1f", viewModel.user.rating),
                rating: viewModel.user.rating
            )

            Divider()
                .frame(height: 40)

            statItem(
                value: "\(viewModel.user.reviewCount)",
                label: "Reviews"
            )
        }
        .padding(.vertical, AppSpacing.md)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.medium))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: AppSpacing.xxs) {
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(AppColors.deepNavy)
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(AppColors.softGray)
        }
        .frame(maxWidth: .infinity)
    }

    private func statItemWithRating(value: String, rating: Double) -> some View {
        VStack(spacing: AppSpacing.xxs) {
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(AppColors.deepNavy)
            RatingView(rating: rating, size: 14)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Bio

    private var bioSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("About")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(AppColors.deepNavy)

            Text(viewModel.user.bio)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(AppColors.softGray)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Specialties

    private var specialtiesSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("Specialties")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(AppColors.deepNavy)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.xs) {
                    ForEach(viewModel.user.specialties) { specialty in
                        CategoryChip(
                            label: specialty.displayName,
                            color: chipColor(for: specialty)
                        )
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Badges

    private var badgesSection: some View {
        Group {
            if !viewModel.user.badges.isEmpty {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("Badges")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(AppColors.deepNavy)

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: AppSpacing.sm
                    ) {
                        ForEach(viewModel.user.badges) { badge in
                            badgeCard(badge)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private func badgeCard(_ badge: Badge) -> some View {
        HStack(spacing: AppSpacing.xs) {
            Image(systemName: badge.iconName)
                .font(.system(size: 20))
                .foregroundStyle(AppColors.accentGold)
                .frame(width: 36, height: 36)
                .background(AppColors.accentGold.opacity(0.12))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: AppSpacing.xxxs) {
                Text(badge.name)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(AppColors.deepNavy)
                    .lineLimit(1)

                Text(badge.description)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(AppColors.softGray)
                    .lineLimit(2)
            }
        }
        .padding(AppSpacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small))
        .shadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)
    }

    // MARK: - Navigation Links

    private var navigationLinks: some View {
        VStack(spacing: AppSpacing.sm) {
            NavigationLink {
                EarningsDashboardView(viewModel: viewModel)
            } label: {
                navigationRow(
                    icon: "dollarsign.circle.fill",
                    title: "Earnings",
                    subtitle: String(format: "$%.2f total", viewModel.totalEarnings),
                    color: AppColors.successGreen
                )
            }

            NavigationLink {
                ReviewsListView(viewModel: viewModel)
            } label: {
                navigationRow(
                    icon: "star.circle.fill",
                    title: "Reviews",
                    subtitle: "\(viewModel.user.reviewCount) reviews",
                    color: AppColors.accentGold
                )
            }
        }
    }

    private func navigationRow(icon: String, title: String, subtitle: String, color: Color) -> some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundStyle(color)

            VStack(alignment: .leading, spacing: AppSpacing.xxxs) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppColors.deepNavy)
                Text(subtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(AppColors.softGray)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppColors.softGray)
        }
        .padding(AppSpacing.md)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.medium))
        .shadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)
    }

    // MARK: - Sign Out

    private var signOutButton: some View {
        PillButton(title: "Sign Out", style: .outline) {
            viewModel.onSignOut?()
        }
        .padding(.top, AppSpacing.sm)
    }

    // MARK: - Helpers

    private func chipColor(for category: TaskCategory) -> Color {
        switch category {
        case .openHouse: return .blue
        case .showing: return .purple
        case .photography: return .orange
        case .inspection: return .teal
        case .staging: return .pink
        case .signInstall: return AppColors.successGreen
        case .lockbox: return .brown
        case .flyerDelivery: return .cyan
        case .research: return .indigo
        case .other: return AppColors.softGray
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ProfileView(
            viewModel: {
                let vm = ProfileViewModel(
                    profileService: MockProfileService(),
                    paymentService: MockPaymentService(),
                    user: SharedModels.MockUsers.currentUser
                )
                vm.loadProfile()
                vm.loadReviews()
                vm.loadEarnings()
                return vm
            }()
        )
    }
}
