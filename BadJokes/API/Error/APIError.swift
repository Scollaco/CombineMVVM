import Foundation

enum APIError: Error {
    case genericError
    case invalidRequest
    case jsonDecoding(error: Error)
}

extension APIError {
    var localizedDescription: String {
        switch self {
        case .genericError:
            return "Something went wrong!"
        case .invalidRequest:
            return "Invalid request!"
        case .jsonDecoding(error: let error):
            return error.localizedDescription
        }
    }
}
