import SwiftUI
import SharedModels
import Networking
import DesignSystem

/// Displays a summary of the user's earnings with a time period segmented control.
public struct EarningsDashboardView: View {

    // MARK: - Types

    enum TimePeriod: String, CaseIterable, Identifiable {
        case thisMonth = "This Month"
        case allTime = "All Time"

        var id: String { rawValue }
    }

    // MARK: - Properties

    @Bindable var viewModel: ProfileViewModel
    @State private var selectedPeriod: TimePeriod = .allTime

    // MARK: - Init

    public init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Computed

    private var displayedPayments: [Payment] {
        switch selectedPeriod {
        case .thisMonth: return viewModel.thisMonthEarnings
        case .allTime: return viewModel.earnings
        }
    }

    private var displayedTotal: Double {
        switch selectedPeriod {
        case .thisMonth: return viewModel.thisMonthTotal
        case .allTime: return viewModel.totalEarnings
        }
    }

    private var completedCount: Int {
        displayedPayments.filter { $0.status == .completed }.count
    }

    private var pendingCount: Int {
        displayedPayments.filter { $0.status == .pending }.count
    }

    private var pendingAmount: Double {
        displayedPayments
            .filter { $0.status == .pending }
            .reduce(0.0) { $0 + $1.amount }
    }

    // MARK: - Body

    public var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                totalEarningsHeader
                periodPicker
                summaryStats
                paymentsList
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.top, AppSpacing.sm)
            .padding(.bottom, AppSpacing.xl)
        }
        .background(AppColors.freshWhite)
        .navigationTitle("Earnings")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.loadEarnings()
        }
    }

    // MARK: - Total Header

    private var totalEarningsHeader: some View {
        VStack(spacing: AppSpacing.xxs) {
            Text("Total Earnings")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(AppColors.softGray)

            Text(String(format: "$%.2f", displayedTotal))
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(AppColors.warmCoral)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.lg)
    }

    // MARK: - Period Picker

    private var periodPicker: some View {
        Picker("Time Period", selection: $selectedPeriod) {
            ForEach(TimePeriod.allCases) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(.segmented)
    }

    // MARK: - Summary Stats

    private var summaryStats: some View {
        HStack(spacing: AppSpacing.sm) {
            summaryCard(
                title: "Completed",
                value: "\(completedCount)",
                color: AppColors.successGreen
            )

            summaryCard(
                title: "Pending",
                value: "\(pendingCount)",
                color: AppColors.warningAmber
            )

            summaryCard(
                title: "Pending $",
                value: String(format: "$%.0f", pendingAmount),
                color: AppColors.warmCoral
            )
        }
    }

    private func summaryCard(title: String, value: String, color: Color) -> some View {
        VStack(spacing: AppSpacing.xxs) {
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(color)

            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(AppColors.softGray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.md)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small))
        .shadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)
    }

    // MARK: - Payments List

    private var paymentsList: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Transactions")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(AppColors.deepNavy)

            if displayedPayments.isEmpty {
                EmptyStateView(
                    icon: "dollarsign.circle",
                    title: "No Transactions",
                    message: "Your earnings will appear here once you complete tasks."
                )
                .frame(height: 200)
            } else {
                ForEach(displayedPayments) { payment in
                    paymentRow(payment)
                }
            }
        }
    }

    private func paymentRow(_ payment: Payment) -> some View {
        HStack(spacing: AppSpacing.sm) {
            VStack(alignment: .leading, spacing: AppSpacing.xxxs) {
                Text(payment.taskTitle)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppColors.deepNavy)
                    .lineLimit(1)

                Text(formatDate(payment.createdAt))
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(AppColors.softGray)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: AppSpacing.xxxs) {
                Text(payment.formattedAmount)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(AppColors.deepNavy)

                StatusBadge(
                    status: payment.status.displayName,
                    color: statusColor(for: payment.status)
                )
            }
        }
        .padding(AppSpacing.md)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small))
        .shadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)
    }

    // MARK: - Helpers

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }

    private func statusColor(for status: PaymentStatus) -> Color {
        switch status {
        case .completed: return AppColors.successGreen
        case .pending: return AppColors.warningAmber
        case .failed: return AppColors.errorRed
        case .refunded: return AppColors.softGray
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        EarningsDashboardView(
            viewModel: {
                let vm = ProfileViewModel(
                    profileService: MockProfileService(),
                    paymentService: MockPaymentService(),
                    user: SharedModels.MockUsers.currentUser
                )
                vm.loadEarnings()
                return vm
            }()
        )
    }
}
