import Foundation

enum NetworkError: Error {
  case invalidRequest
  case jsonDecoding(error: Error)
}
