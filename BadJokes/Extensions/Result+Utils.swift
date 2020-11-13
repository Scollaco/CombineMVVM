import Foundation

extension Result {
    var isSuccess: Bool {
        switch self {
        case .success(_):
          return true
        default:
          return false
        }
    }

    var isFailure: Bool {
        return !isSuccess
    }
}
