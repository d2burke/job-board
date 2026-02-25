import Foundation

public enum NetworkingError: LocalizedError, Sendable {
    case notFound
    case unauthorized
    case serverError(String)
    case networkUnavailable
    case decodingError
    case unknown

    public var errorDescription: String? {
        switch self {
        case .notFound:
            return "The requested resource was not found."
        case .unauthorized:
            return "You are not authorized to perform this action."
        case .serverError(let message):
            return "Server error: \(message)"
        case .networkUnavailable:
            return "Network is unavailable. Please check your connection."
        case .decodingError:
            return "Failed to process the server response."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
