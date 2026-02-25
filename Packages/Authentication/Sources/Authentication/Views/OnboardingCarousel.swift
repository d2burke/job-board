import SwiftUI
import DesignSystem

/// A three-page onboarding carousel introducing the app's core value propositions.
struct OnboardingCarousel: View {

    // MARK: - Properties

    @Bindable var viewModel: AuthViewModel
    @State private var currentPage: Int = 0

    // MARK: - Data

    private let pages: [(icon: String, title: String, description: String)] = [
        (
            "magnifyingglass",
            "Find Tasks Near You",
            "Browse available real estate tasks in your area. From open houses to property photography, discover opportunities that match your skills."
        ),
        (
            "calendar.badge.clock",
            "Earn on Your Schedule",
            "Accept tasks that fit your availability. Work when you want, where you want, and build a flexible income stream as a real estate professional."
        ),
        (
            "star.fill",
            "Build Your Reputation",
            "Complete tasks, earn great reviews, and unlock badges. Your profile grows with every successful assignment, attracting more opportunities."
        )
    ]

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    onboardingPage(
                        icon: pages[index].icon,
                        title: pages[index].title,
                        description: pages[index].description
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))

            // Bottom actions
            VStack(spacing: AppSpacing.md) {
                PillButton(
                    title: currentPage == pages.count - 1 ? "Continue" : "Next",
                    style: .primary
                ) {
                    withAnimation {
                        if currentPage < pages.count - 1 {
                            currentPage += 1
                        } else {
                            viewModel.goToSignIn()
                        }
                    }
                }

                Button {
                    viewModel.goToSignIn()
                } label: {
                    Text("Skip")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(AppColors.softGray)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, AppSpacing.xxl)
        }
        .background(AppColors.freshWhite)
        .navigationBarBackButtonHidden()
    }

    // MARK: - Onboarding Page

    private func onboardingPage(icon: String, title: String, description: String) -> some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()

            // Icon circle
            ZStack {
                Circle()
                    .fill(AppColors.warmCoral.opacity(0.1))
                    .frame(width: 140, height: 140)

                Image(systemName: icon)
                    .font(.system(size: 56, weight: .medium))
                    .foregroundStyle(AppColors.warmCoral)
            }

            // Title
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(AppColors.deepNavy)
                .multilineTextAlignment(.center)

            // Description
            Text(description)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(AppColors.softGray)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, AppSpacing.xl)

            Spacer()
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        OnboardingCarousel(viewModel: AuthViewModel(authService: MockAuthService()))
    }
}
