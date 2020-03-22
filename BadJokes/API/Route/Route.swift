import Foundation

enum Method: String {
  case GET
}

enum Route {
  case fetchJoke
  
  var properties: (path: String, parameters: [String: CustomStringConvertible], method: Method) {
    switch self {
    case .fetchJoke:
      return (path: "/joke", parameters: [:], method: .GET)
    }
  }
}
