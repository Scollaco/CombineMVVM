import Combine
import Foundation

final class Service: ServiceType {
  
  func load<T>(_ resource: Resource<T>) -> AnyPublisher<Result<T, APIError>, Never> where T: Decodable {
    guard let request = resource.request else {
      return .just(.failure(.invalidRequest))
    }

    return URLSession.shared.dataTaskPublisher(for: request)
      .mapError { _ in APIError.invalidRequest }
      .tryMap { $0.data }
      .decode(type: T.self, decoder: JSONDecoder())
      .map { .success($0) }
      .catch { error -> AnyPublisher<Result<T, APIError>, Never> in
          return .just(.failure(APIError.jsonDecoding(error: error)))
      }
      .eraseToAnyPublisher()
  }
}
