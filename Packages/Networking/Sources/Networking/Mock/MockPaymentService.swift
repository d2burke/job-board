import Foundation
import SharedModels

@MainActor
public final class MockPaymentService: PaymentServiceProtocol {
    private var payments: [Payment]

    public init() {
        let completedTasks = MockTasks.allTasks.filter { $0.status == .completed }
        self.payments = completedTasks.map { task in
            Payment(
                id: "payment-\(task.id)",
                taskId: task.id,
                amount: task.compensation,
                status: .completed,
                payerId: task.postedBy.id,
                payeeId: task.assignedTo?.id ?? MockUsers.currentUser.id,
                createdAt: task.createdAt,
                taskTitle: task.title
            )
        }

        // Add some additional mock payments for a richer dataset
        self.payments.append(contentsOf: [
            Payment(
                id: "payment-extra-001",
                taskId: "task-past-001",
                amount: 120.0,
                status: .completed,
                payerId: MockUsers.otherUser1.id,
                payeeId: MockUsers.currentUser.id,
                createdAt: Calendar.current.date(byAdding: .day, value: -14, to: Date())!,
                taskTitle: "Open House at 900 Birch Lane"
            ),
            Payment(
                id: "payment-extra-002",
                taskId: "task-past-002",
                amount: 85.0,
                status: .completed,
                payerId: MockUsers.otherUser3.id,
                payeeId: MockUsers.currentUser.id,
                createdAt: Calendar.current.date(byAdding: .day, value: -21, to: Date())!,
                taskTitle: "Photography at Sunset Estates"
            ),
            Payment(
                id: "payment-extra-003",
                taskId: "task-past-003",
                amount: 200.0,
                status: .pending,
                payerId: MockUsers.otherUser1.id,
                payeeId: MockUsers.currentUser.id,
                createdAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                taskTitle: "Staging at Riverside Condo"
            )
        ])
    }

    nonisolated public func fetchEarnings() async throws -> [Payment] {
        try await Task.sleep(for: .milliseconds(300))
        let allPayments = await MainActor.run { self.payments }
        return allPayments.sorted { $0.createdAt > $1.createdAt }
    }

    nonisolated public func fetchTotalEarnings() async throws -> Double {
        try await Task.sleep(for: .milliseconds(300))
        let allPayments = await MainActor.run { self.payments }
        return allPayments
            .filter { $0.status == .completed }
            .reduce(0) { $0 + $1.amount }
    }

    nonisolated public func requestPayout(amount: Double) async throws {
        try await Task.sleep(for: .milliseconds(500))
        print("[MockPaymentService] Payout of $\(String(format: "%.2f", amount)) requested successfully.")
    }
}
