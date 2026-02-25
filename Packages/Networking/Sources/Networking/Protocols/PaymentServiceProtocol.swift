import SharedModels

public protocol PaymentServiceProtocol: Sendable {
    func fetchEarnings() async throws -> [Payment]
    func fetchTotalEarnings() async throws -> Double
    func requestPayout(amount: Double) async throws
}
